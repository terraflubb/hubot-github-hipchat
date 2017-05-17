module.exports =
  map: (eventType, payload) ->
    if eventType == 'ping'
      return 'noop'

    if eventType == 'push'
      if payload.created
        return "push"
      else
        return "noop"

    if eventType == 'issue_comment' and payload.action == 'created' and
        payload.issue.pull_request?
      return 'pull_request_commented'

    if eventType == 'pull_request' and payload.action == 'closed' and
        payload.pull_request.merged
      return 'pull_request_merged'

    "#{eventType}_#{payload.action}"