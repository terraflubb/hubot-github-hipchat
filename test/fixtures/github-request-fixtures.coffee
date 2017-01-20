createRepository = ->
  id: 35129377
  name: "science"
  full_name: "nedap/science"

createUser = ->
  base_user_url = 'https://api.github.com/users/terraflubb/'

  login: "terraflubb"
  id: 6752317
  avatar_url: "https://avatars.githubusercontent.com/u/6752317?v=3"
  gravatar_id: ""
  url: "https://api.github.com/users/terraflubb"
  html_url: "https://github.com/terraflubb"
  followers_url: "#{base_user_url}followers"
  following_url: "#{base_user_url}following{/other_user}"
  gists_url: "#{base_user_url}gists{/gist_id}"
  starred_url: "#{base_user_url}starred{/owner}{/repo}"
  subscriptions_url: "#{base_user_url}subscriptions"
  organizations_url: "#{base_user_url}orgs"
  repos_url: "#{base_user_url}repos"
  events_url: "#{base_user_url}events{/privacy}"
  received_events_url: "#{base_user_url}received_events"
  type: "User"
  site_admin: false

module.exports =
  createUser: createUser
  createRepository: createRepository
