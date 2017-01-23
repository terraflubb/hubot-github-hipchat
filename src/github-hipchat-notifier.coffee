# Description:
#   Listens to github notifications and reports them
#
# Configuration:
#   HUBOT_HIPCHAT_GITHUB_NOTIFICATION_ROOM (the room we announce to)
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

NOTIFICATION_ROOM = process.env.HUBOT_HIPCHAT_GITHUB_NOTIFICATION_ROOM or ''

eventHandlers = require("./notifications/events.coffee")

module.exports = (robot) ->

  robot.router.post '/hubot/github-events', (req, res) ->
    payload = req.body
    eventType = req.headers["x-github-event"]
    response = handleEvent(eventType, payload)
    robot.messageRoom(NOTIFICATION_ROOM, response) if response?

    res.send 'OK'


handleEvent = (eventType, payload) ->
  # This eats 'pull' and 'ping' events so eventually
  # we'll handle them better
  return null unless payload.action? and eventType

  handler = eventHandlers[eventType][payload.action]
  return handler payload if handler?
  console.log "Cannot handle event: #{eventType}::#{payload.action}"
