module.exports = (raw) ->
  parsed =
    repo:
      name: raw.repository.full_name
      url: raw.repository.html_url
    who:
      name: raw.sender.login
      url: raw.sender.html_url

  if raw.pull_request?
    parsed.pr =
        title: raw.pull_request.title
        number: raw.pull_request.number
        url: raw.pull_request.html_url

  if raw.issue?
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