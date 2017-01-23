templates = require('dot').process(path: './views')

module.exports =
  pull_request:
    opened: (payload) ->
      data =
        user: payload.pull_request.user.login
        pr:
          number: payload.number
          title: payload.pull_request.title
        repo: payload.repository.full_name

      templates.pull_request_opened(data)

    closed: (payload) ->
      data =
        user: payload.pull_request.user.login
        pr:
          number: payload.number
          title: payload.pull_request.title
        repo: payload.repository.full_name

      if payload.pull_request.merged
        templates.pull_request_merged(data)
      else
        templates.pull_request_closed(data)

  issues:
    opened: (payload) ->
      data =
        user: payload.issue.user.login
        issue:
          number: payload.issue.number
          title: payload.issue.title
        repo: payload.repository.full_name

      templates.issues_opened(data)

  issue_comment:
    created: (payload) ->
      data =
        user: payload.comment.user.login
        pr:
          number: payload.issue.number
          title: payload.issue.title
        issue:
          number: payload.issue.number
          title: payload.issue.title
        repo: payload.repository.full_name

      if payload.issue.pull_request?
        templates.pull_request_commented(data)
      else
        templates.issue_comment_created(data)
