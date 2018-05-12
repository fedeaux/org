import BaseAdapter from './base_adapter'

class Video extends BaseAdapter
  constructor: ->
    super()
    @vue_component_name = 'tats-targets-video'

  targetAttributes: (start, duration = 3) ->
    start: start
    duration: duration
    type: @targetType()
    identifier: @targetIdentifier()

export default Video
