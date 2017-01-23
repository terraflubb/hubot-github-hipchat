
module.exports = (payload) ->
  parsed =
    repo: payload.repository.full_name

  if payload.pull_request?
    parsed.pr = payload.pull_request
    parsed.who = payload.pull_request.user.login

  if payload.issue?
    parsed.who = payload.issue.user.login

    parsed.issue =
      number: payload.issue.number
      title: payload.issue.title

    if payload.issue.pull_request?
      parsed.pr =
        title: payload.issue.title
        number: payload.issue.number
        url: payload.issue.pull_request.html_url

  parsed