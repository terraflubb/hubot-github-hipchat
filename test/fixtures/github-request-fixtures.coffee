createRepository = ->
 JSON.parse(JSON.stringify({
    "id": 35129377,
    "name": "science",
    "full_name": "nedap/science"
  }))

createUser = ->
 JSON.parse(JSON.stringify({
    "login": "terraflubb",
    "id": 6752317,
    "avatar_url": "https://avatars.githubusercontent.com/u/6752317?v=3",
    "gravatar_id": "",
    "url": "https://api.github.com/users/terraflubb",
    "html_url": "https://github.com/terraflubb",
    "followers_url": "https://api.github.com/users/terraflubb/followers",
    "following_url": "https://api.github.com/users/terraflubb/following{/other_user}",
    "gists_url": "https://api.github.com/users/terraflubb/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/terraflubb/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/terraflubb/subscriptions",
    "organizations_url": "https://api.github.com/users/terraflubb/orgs",
    "repos_url": "https://api.github.com/users/terraflubb/repos",
    "events_url": "https://api.github.com/users/terraflubb/events{/privacy}",
    "received_events_url": "https://api.github.com/users/terraflubb/received_events",
    "type": "User",
    "site_admin": false
  }))

module.exports = {
  createUser: createUser,
  createRepository: createRepository
}
