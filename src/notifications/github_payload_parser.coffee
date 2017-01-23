
module.exports = (raw) ->
  parsed =
    repo: raw.repository.full_name

  if raw.pull_request?
    parsed.pr = raw.pull_request
    parsed.who = raw.pull_request.user.login

  if raw.issue?
    parsed.who = raw.issue.user.login

    parsed.issue =
      number: raw.issue.number
      title: raw.issue.title

    if raw.issue.pull_request?
      parsed.pr =
        title: raw.issue.title
        number: raw.issue.number
        url: raw.issue.pull_request.html_url

  parsed