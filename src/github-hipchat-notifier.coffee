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


request = require('request')
dot = require('dot')
dot.templateSettings.strip = false
dot.log = false
templates = dot.process(path: __dirname + '/../views')

mapEventToTemplate = require("./notifications/map_event_to_template.coffee")
payloadParser = require('./notifications/github_payload_parser.coffee')
hipchat = require('./notifications/notify_hipchat.coffee')

renderResponse = (eventType, payload) ->
  template_handle = mapEventToTemplate.map(eventType, payload)

  if template_handle == 'noop' or not templates[template_handle]
    return null

  templates[template_handle](payloadParser(payload))

module.exports = (robot) ->
  robot.router.post '/hubot/github-events', (req, res) ->
    payload = req.body
    eventType = req.headers["x-github-event"]
    response = renderResponse(eventType, payload)
    hipchat.send(response) if response

    res.send 'OK'
