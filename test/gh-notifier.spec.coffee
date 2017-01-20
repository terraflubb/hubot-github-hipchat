chai = require 'chai'
expect = chai.expect
Helper = require('hubot-test-helper')
helper = new Helper('../src/github-hipchat-notifier.coffee')
request = require('request')
fixtures = require("./fixtures/github-request-fixtures.coffee")

process.env.EXPRESS_PORT = 9999

describe 'gh-notifier', ->

  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'handles a "pull request opened" notification', (done) ->
    request.post mockGithubRequest('pull_request', 'opened'), (res, req) =>
      expect(@room.messages).to.eql([
        ['hubot', 'nedap/science: terraflubb opened PR #1: "This is the title of the pull request"']
      ])
      done()

  it 'handles a "pull request closed (merged)" notification', (done) ->
    payload = mockGithubRequest('pull_request', 'closed')
    payload.json.pull_request.merged = true;
    request.post payload, (res, req) =>
      expect(@room.messages).to.eql([
        ['hubot', 'nedap/science: terraflubb merged PR #1.']
      ])
      done()

  it 'handles a "pull request closed (unmerged)" notification', (done) ->
    payload = mockGithubRequest('pull_request', 'closed')
    payload.json.pull_request.merged = false;
    request.post payload, (res, req) =>
      expect(@room.messages).to.eql([
        ['hubot', 'nedap/science: terraflubb closed PR #1.']
      ])
      done()

  it 'handles a "issue opened" notification', (done) ->
    request.post mockGithubRequest('issues', 'opened'), (res, req) =>
      expect(@room.messages).to.eql([
        ['hubot', 'nedap/science: terraflubb created issue #1: "This is the title of the issue"']
      ])
      done()

  it 'handles a "issue comment created" notification', (done) ->
    request.post mockGithubRequest('issue_comment', 'created'), (res, req) =>
      expect(@room.messages).to.eql([
        ['hubot', 'nedap/science: terraflubb commented on issue #1']
      ])
      done()

  it 'handles a "issue comment created" notification (when the issue is a PR)', (done) ->
    payload = mockGithubRequest('issue_comment', 'created')
    payload.json.issue.pull_request = {lol: "bogus_pr!!!"}
    request.post payload, (res, req) =>
      expect(@room.messages).to.eql([
        ['hubot', 'nedap/science: terraflubb commented on PR #1']
      ])
      done()

  it 'can deal with a ping', (done) ->
    request.post {
        method: 'POST',
        headers: {
          'X-GitHub-Event': 'ping'
        },
        uri: 'http://127.0.0.1:9999/hubot/github-events',
        json: {zen: "banana", hook_id: 123, hook: "lol"}
      }
      , (res, req) =>
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
      action: 'opened',
      number: 1,
      repository: fixtures.createRepository(),
      pull_request: {
        url: "https://api.github.com/repo/public-repo/pulls/1",
        id: 34778301,
        title: "This is the title of the pull request",
        user: fixtures.createUser()
      }
    }
  else if eventType == 'pull_request' and action == 'closed'
    return {
      action: 'closed',
      number: 1,
      repository: fixtures.createRepository(),
      pull_request: {
        url: 'https://api.github.com/repo/public-repo/pulls/1',
        id: 34778301,
        title: "This is the title of the pull request",
        user: fixtures.createUser(),
        merged: true
      }
    }
  else if eventType == 'issues' and action == 'opened'
    return {
      action: 'opened',
      repository: fixtures.createRepository(),
      issue: {
        number: 1,
        id: 34778301,
        title: 'This is the title of the issue',
        user: fixtures.createUser()
      }
    }
  else if eventType = 'issue_comment' and action == 'created'
    return {
      action: 'created',
      repository: fixtures.createRepository(),
      issue: {
        number: 1,
        id: 34778301,
        title: 'This is the title of the issue',
      },
      comment: {
        user: fixtures.createUser()
      }
    }
