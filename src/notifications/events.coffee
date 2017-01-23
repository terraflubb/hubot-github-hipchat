payloadParser = require('./github_payload_parser.coffee')
dot = require('dot')
dot.log = false
templates = dot.process(path: './views')

module.exports =
  pull_request:
    opened: (payload) ->
      data = payloadParser(payload)
      templates.pull_request_opened(data)

    closed: (payload) ->
      data = payloadParser(payload)

      if payload.pull_request.merged
        templates.pull_request_merged(data)
      else
        templates.pull_request_closed(data)

  issues:
    opened: (payload) ->
      data = payloadParser(payload)
      templates.issues_opened(data)

  issue_comment:
    created: (payload) ->
      data = payloadParser(payload)

      if payload.issue.pull_request?
        templates.pull_request_commented(data)
      else
        templates.issue_comment_created(data)
