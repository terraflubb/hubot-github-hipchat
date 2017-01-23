createRepository = ->
  require("./repository.json")

createUser = ->
  require("./user.json")

createPR = (params) ->
  pr = require("./pr.json")
  pr.user = createUser()
  pr.merged = true if params?merged
  return pr

createIssue = ->
  issue = require("./issue.json")
  issue.user = createUser()
  return issue

createIssuePRExtension = ->
  url: "https://api.github.com/repos/nedap/steppingstone-hubot/pulls/41"
  html_url: "https://github.com/nedap/steppingstone-hubot/pull/41"
  diff_url: "https://github.com/nedap/steppingstone-hubot/pull/41.diff"
  patch_url: "https://github.com/nedap/steppingstone-hubot/pull/41.patch"

module.exports =
  createUser: createUser
  createRepository: createRepository
  createPR: createPR
  createIssue: createIssue
  createIssuePRExtension: createIssuePRExtension