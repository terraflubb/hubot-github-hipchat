chai = require 'chai'
expect = chai.expect
fixtures = require("./fixtures/github-request-fixtures.coffee")
parser = require("../src/notifications/github_payload_parser.coffee")

describe 'Payload Parser', ->

  context 'which contain a pull request', ->
    beforeEach ->
      @raw =
        action: 'opened'
        number: 1
        repository: fixtures.createRepository()
        pull_request: fixtures.createPR()
      @payload = parser(@raw)

    it 'assigns its creator\'s login to who', ->
      expect(@payload.who).to.eql(@raw.pull_request.user.login)

    it 'maps the pull_request to pr', ->
      expect(@payload.pr).to.eql(@raw.pull_request)

  context 'which contain an issue', ->
    beforeEach ->
      @raw =
        action: 'opened'
        number: 1
        repository: fixtures.createRepository()
        issue: fixtures.createIssue()
      @payload = parser(@raw)

    it 'assigns its creator\'s login to who', ->
      expect(@payload.who).to.eql(@raw.issue.user.login)

    it 'maps the issue to issue', ->
      expect(@payload.issue).to.eql(@raw.issue)

  context 'which contain an issue which is a PR', ->
    beforeEach ->
      @raw =
        action: 'opened'
        number: 1
        repository: fixtures.createRepository()
        issue: fixtures.createIssue()
      @raw.issue.pull_request = fixtures.createIssuePRExtension()
      @payload = parser(@raw)

    it 'knows it is a PR', ->
      expect(@payload.pr?).to.be.true

    it 'includes the HTML URLs to the PR', ->
      expect(@payload.pr.url).to.eql(@raw.issue.pull_request.html_url)

    it 'adds the issue number to the PR for convenience', ->
      expect(@payload.pr.number).to.eql(@raw.issue.number)

