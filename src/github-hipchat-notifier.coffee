# Description:
#   Listens to github notifications and reports them
#
# Configuration:
#   HUBOT_HIPCHAT_GITHUB_NOTIFICATION_ROOM_API_ID (the room we announce to)
#   HUBOT_HIPCHAT_GITHUB_HUBOT_API_TOKEN (auth for the user annoucing)
#
# Commands:
#    No commands, it just listens to /hubot/github-events on port 8080
#
# Notes:
#   Make sure to set up the github hook to point at this
#
# Author:
#   SteppingStone

dot = require('dot')
dot.templateSettings.strip = false
dot.log = false
templates = dot.process(path: __dirname + '/../views')

mapEventToTemplate = require("./notifications/map_event_to_template.coffee")
payloadParser = require('./notifications/github_payload_parser.coffee')
hipchat = require('./notifications/notify_hipchat.coffee')

findTemplate = (eventType, payload) ->
  template_handle = mapEventToTemplate.map(eventType, payload)
  if template_handle == 'noop' or not templates[template_handle]
    return null

  templates[template_handle]

module.exports = (robot) ->
  robot.router.post '/hubot/github-events', (req, res) ->
    payload = req.body
    eventType = req.headers["x-github-event"]

    template = findTemplate(eventType, payload)

    if template?
      parsedPayload = payloadParser(payload)
      response = template(parsedPayload)
      header = parsedPayload.repo.name
      hipchat.send(response, header)

    res.send 'OK'
