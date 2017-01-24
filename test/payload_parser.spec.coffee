chai = require 'chai'
expect = chai.expect
fixtures = require("./fixtures/github-request-fixtures.coffee")
parser = require("../src/notifications/github_payload_parser.coffee")

describe 'Payload Parser', ->
  beforeEach ->
    @raw = repository: fixtures.createRepository()

  it "should map the repository name to a handy accessor", ->
    payload = parser(@raw)
    expect(payload.repo.name).to.eql(@raw.repository.full_name)

  it "should map the repository name to a handy accessor", ->
    payload = parser(@raw)
    expect(payload.repo.url).to.eql(@raw.repository.html_url)

  context 'which contain a pull request', ->
    beforeEach ->
      @raw.action = 'opened'
      @raw.pull_request = fixtures.createPR()
      @payload = parser(@raw)

    it 'assigns its creator\'s login to who', ->
      expect(@payload.who.name).to.eql(@raw.pull_request.user.login)

    it 'assigns its creator\'s URL to who_url', ->
      expect(@payload.who.url).to.eql(@raw.pull_request.user.html_url)

    it 'maps the pull request title to the pr property', ->
      expect(@payload.pr.title).to.eql(@raw.pull_request.title)

    it 'maps the pull request number to the pr property', ->
      expect(@payload.pr.number).to.eql(@raw.pull_request.number)

  context 'which contain an issue (but no comment)', ->
    beforeEach ->
      @raw.action = 'opened'
      @raw.issue = fixtures.createIssue()
      @payload = parser(@raw)

    it 'assigns its creator\'s login to who', ->
      expect(@payload.who.name).to.eql(@raw.issue.user.login)

    it 'assigns its creator\'s URL to who_url', ->
      expect(@payload.who.url).to.eql(@raw.issue.user.html_url)

    it 'maps the issue number', ->
      expect(@payload.issue.number).to.eql(@raw.issue.number)

    it 'maps the issue title', ->
      expect(@payload.issue.title).to.eql(@raw.issue.title)

  context 'which contain a comment and an issue', ->
    beforeEach ->
      @raw.action = 'created'
      @raw.issue = fixtures.createIssue()
      @raw.comment = fixtures.createComment()
      @raw.issue.pull_request = fixtures.createIssuePRExtension()
      @payload = parser(@raw)

    it 'uses the comment author as the who', ->
      expect(@payload.who.name).to.eql(@raw.comment.user.login)
      expect(@payload.who.url).to.eql(@raw.comment.user.html_url)


  context 'which contain an issue which is a PR', ->
    beforeEach ->
      @raw.action = 'opened'
      @raw.issue = fixtures.createIssue()
      @raw.issue.pull_request = fixtures.createIssuePRExtension()
      @payload = parser(@raw)

    it 'knows it is a PR', ->
      expect(@payload.pr?).to.be.true

    it 'includes the HTML URLs to the PR', ->
      expect(@payload.pr.url).to.eql(@raw.issue.pull_request.html_url)

    it 'assigns its creator\'s URL to who_url', ->
      expect(@payload.who.url).to.eql(@raw.issue.user.html_url)

    it 'adds the issue title to the PR for convenience', ->
      expect(@payload.pr.title).to.eql(@raw.issue.title)

    it 'adds the issue number to the PR for convenience', ->
      expect(@payload.pr.number).to.eql(@raw.issue.number)

