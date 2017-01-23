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

dot = require('dot')
dot.log = false

mapEventToTemplate = require("./notifications/map_event_to_template.coffee")
payloadParser = require('./notifications/github_payload_parser.coffee')

templates = dot.process(path: './views')

handleEvent = (eventType, payload) ->
  template_handle = mapEventToTemplate(eventType, payload)

  if template_handle == 'noop' or not templates[template_handle]
    return null

  templates[template_handle](payloadParser(payload))

module.exports = (robot) ->

  robot.router.post '/hubot/github-events', (req, res) ->
    payload = req.body
    eventType = req.headers["x-github-event"]
    response = handleEvent(eventType, payload)
    robot.messageRoom(NOTIFICATION_ROOM, response) if response?

    res.send 'OK'
