module.exports =
  pull_request:
    opened: (payload) ->
      user = payload.pull_request.user.login
      pr_number = payload.number
      title = payload.pull_request.title
      repo = payload.repository.full_name

      "#{repo}: #{user} opened PR ##{pr_number}: \"#{title}\""

    closed: (payload) ->
      user = payload.pull_request.user.login
      pr_number = payload.number
      title = payload.pull_request.title
      repo = payload.repository.full_name
      verb = if payload.pull_request.merged then 'merged' else 'closed'

      "#{repo}: #{user} #{verb} PR ##{pr_number}."

  issues:
    opened: (payload) ->
      user = payload.issue.user.login
      number = payload.issue.number
      title = payload.issue.title
      repo = payload.repository.full_name

      "#{repo}: #{user} created issue ##{number}: \"#{title}\""

  issue_comment:
    created: (payload) ->
      user = payload.comment.user.login
      number = payload.issue.number
      repo = payload.repository.full_name
      noun = if payload.issue.pull_request? then 'PR' else 'issue'

      "#{repo}: #{user} commented on #{noun} ##{number}"
