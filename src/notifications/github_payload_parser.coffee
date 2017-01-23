
module.exports = (payload) ->
  parsed =
    repo: payload.repository.full_name

  if payload.pull_request?
    parsed.pr = payload.pull_request
    parsed.who = payload.pull_request.user.login

  if payload.issue?
    parsed.issue = payload.issue
    parsed.who = payload.issue.user.login
    if parsed.issue.pull_request?
      parsed.pr =
        number: parsed.issue.number
        url: parsed.issue.pull_request.html_url



  parsed