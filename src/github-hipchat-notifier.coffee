# Description:
#   Listens to github notifications and reports them
#
# Configuration:
#   GIT_NOTIFICATION_ROOM (the room we announce to)
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   SteppingStone

NOTIFICATION_ROOM = process.env['GIT_NOTIFICATION_ROOM']

issueHandlers = require("./issueHandlers.coffee")

module.exports = (robot) ->

  robot.router.post '/hubot/github-events', (req, res) ->
    payload = req.body
    eventType = req.headers["x-github-event"]
    response = handleEvent(eventType, payload)

    robot.messageRoom("hubot", response) if response?

    res.send 'OK'


handleEvent = (eventType, payload) ->
  return null if eventType is "ping"

  handler = issueHandlers[eventType][payload.action]
  return handler payload if handler?
  console.log "Cannot handle event: #{eventType}::#{payload.action}"
