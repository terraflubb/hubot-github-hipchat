chai = require 'chai'
expect = chai.expect
fixtures = require("./fixtures/github-request-fixtures.coffee")
mapper = require("../src/notifications/map_event_to_template.coffee")

describe "Event to template mapper", ->

  it 'should map "ping"  to noop', ->
    mapped = mapper('ping')
    expect(mapped).to.eql('noop')

  it 'should map "push"  to noop', ->
    mapped = mapper('push')
    expect(mapped).to.eql('noop')

  it 'normally maps to "object_type" underscore "payload.action"', ->
    object_type = "banana_apple"
    action =  "blend"
    mapped = mapper(object_type, {action: action})
    expect(mapped).to.eql("banana_apple_blend")

  it 'will map PR issue comments to the PR template', ->
    payload =
      action: 'created'
      issue:
        pull_request: 'exists'
    mapped = mapper('issue_comment', payload)
    expect(mapped).to.eql("pull_request_commented")

  it 'will map PR closed to the merged template if it was merged', ->
    payload =
      action: 'closed'
      pull_request:
        merged: true
    mapped = mapper('pull_request', payload)
    expect(mapped).to.eql("pull_request_merged")