module.exports = (raw) ->
  parsed =
    repo:
      name: raw.repository.full_name
      url: raw.repository.html_url

  if raw.pull_request?
    parsed.pr = raw.pull_request
    parsed.who =
      name: raw.pull_request.user.login
      url: raw.pull_request.user.html_url

  if raw.issue?
    if not raw.comment?
      parsed.who =
        name: raw.issue.user.login
        url: raw.issue.user.html_url
    else
      parsed.who =
        name: raw.comment.user.login
        url: raw.comment.user.html_url

    parsed.issue =
      number: raw.issue.number
      title: raw.issue.title
      url: raw.issue.html_url

    if raw.issue.pull_request?
      parsed.pr =
        title: raw.issue.title
        number: raw.issue.number
        url: raw.issue.pull_request.html_url

  parsed