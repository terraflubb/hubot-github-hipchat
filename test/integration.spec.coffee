request = require 'request'

sinon = require 'sinon'
chai = require 'chai'
sinonChai = require 'sinon-chai'
Helper = require 'hubot-test-helper'

fixtures = require './fixtures/github-request-fixtures.coffee'

expect = chai.expect
chai.use sinonChai

helper = new Helper('../src/github-hipchat-notifier.coffee')

process.env.EXPRESS_PORT = 9999
process.env.ENVIRONMENT = 'testing'

hipchat = require('../src/notifications/notify_hipchat.coffee')
mapper = require('../src/notifications/map_event_to_template.coffee')

describe 'gh-notifier', ->

  before ->
    @hipchatCallStub = sinon.stub(hipchat, 'send')
    @mapperSpy = sinon.spy(mapper, 'map')

  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()
    @mapperSpy.reset()
    @hipchatCallStub.reset()

  it 'handles a "pull request opened" notification', (done) ->
    request.post mockGithubRequest('pull_request', 'opened'), (res, req) =>
      expect(@hipchatCallStub).to.have.callCount 1
      expect(@mapperSpy).to.have.always.returned 'pull_request_opened'
      done()

  it 'handles a "pull request closed (merged)" notification', (done) ->
    payload = mockGithubRequest('pull_request', 'closed')
    payload.json.pull_request.merged = true
    request.post payload, (res, req) =>
      expect(@hipchatCallStub).to.have.callCount 1
      expect(@mapperSpy).to.have.always.returned 'pull_request_merged'
      done()

  it 'handles a "pull request closed (unmerged)" notification', (done) ->
    payload = mockGithubRequest('pull_request', 'closed')
    payload.json.pull_request.merged = false
    request.post payload, (res, req) =>
      expect(@hipchatCallStub).to.have.callCount 1
      expect(@mapperSpy).to.have.always.returned 'pull_request_closed'
      done()

  it 'handles a "issue opened" notification', (done) ->
    request.post mockGithubRequest('issues', 'opened'), =>
      expect(@hipchatCallStub).to.have.callCount 1
      expect(@mapperSpy).to.have.always.returned 'issues_opened'
      done()

  it 'handles a "issue comment created" notification', (done) ->
    request.post mockGithubRequest('issue_comment', 'created'), =>
      expect(@hipchatCallStub).to.have.callCount 1
      expect(@mapperSpy).to.have.always.returned 'issue_comment_created'
      done()

  it 'handles a "issue comment created" notification (for PR)', (done) ->
    payload = mockGithubRequest('issue_comment', 'created')
    payload.json.issue.pull_request = fixtures.createIssuePRExtension()
    request.post payload, =>
      expect(@hipchatCallStub).to.have.callCount 1
      expect(@mapperSpy).to.have.always.returned 'pull_request_commented'
      done()

  it 'can deal with something legal but unexpected', (done) ->
    request.post {
      method: 'POST'
      headers:
        'X-GitHub-Event': 'watermelon'
      uri: 'http://127.0.0.1:9999/hubot/github-events'
      json:
        action: 'squash'
    }, =>
      expect(@hipchatCallStub.callCount).to.equal 0
      done()

  it 'can deal with a ping', (done) ->
    request.post {
      method: 'POST'
      headers:
        'X-GitHub-Event': 'ping'
      uri: 'http://127.0.0.1:9999/hubot/github-events'
      json:
        zen: "banana"
        hook_id: 123
        hook: "lol"
    }, =>
      expect(@hipchatCallStub.callCount).to.equal 0
      done()

  it 'can handle payloads without an action in the JSON', (done) ->
    request.post mockGithubRequest('push', undefined), =>
      expect(@hipchatCallStub.callCount).to.equal 0
      done()


mockGithubRequest = (eventType, action) ->
  {
    method: 'POST',
    headers: {
      'X-GitHub-Event': eventType
    },
    uri: 'http://127.0.0.1:9999/hubot/github-events',
    json: getPayloadFor(eventType, action) or {action: "bogus"}
  }

getPayloadFor = (eventType, action) ->

  if eventType == 'pull_request' and action == 'opened'
    return {
      action: 'opened'
      number: 1
      repository: fixtures.createRepository()
      pull_request: fixtures.createPR()
      sender: fixtures.createUser()
    }

  else if eventType == 'pull_request' and action == 'closed'
    return {
      action: 'closed'
      number: 1
      repository: fixtures.createRepository()
      pull_request: fixtures.createPR(merged: true)
      sender: fixtures.createUser()
    }
  else if eventType == 'issues' and action == 'opened'
    return {
      action: 'opened'
      repository: fixtures.createRepository()
      issue: fixtures.createIssue()
      sender: fixtures.createUser()
    }
  else if eventType = 'issue_comment' and action == 'created'
    return {
      action: 'created'
      repository: fixtures.createRepository()
      issue: fixtures.createIssue()
      comment:
        user: fixtures.createUser()
      sender: fixtures.createUser()
    }
  else
    return { }

