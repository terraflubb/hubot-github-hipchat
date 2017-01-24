request = require('request')

module.exports =
  send: (response, header = "") ->
    return if process.env.ENVIRONMENT == 'testing'

    room = process.env.HUBOT_HIPCHAT_GITHUB_NOTIFICATION_ROOM_API_ID
    token = process.env.HUBOT_HIPCHAT_GITHUB_HUBOT_API_TOKEN
    url = "https://api.hipchat.com/v2/room/#{room}/notification" +
          "?auth_token=#{token}"

    body =
          from: header || "GitHub"
          message: response

    request {method: 'POST', url: url, json: body}, (e, r, b) ->
