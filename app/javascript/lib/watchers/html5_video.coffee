import BaseVideo from './base_video'

class Html5Video extends BaseVideo
  constructor: (@callbacks) ->
    @findVideoEl()

  foundVideoEl: ->
    @video_el.on 'timeupdate', @timeUpdated
    @callbacks.installSuccess()

  findVideoEl: =>
    @video_el = $ @videoElSelector()

    if @noVideoEl()
      clearTimeout @video_finder_timeout
      @video_finder_timeout = setTimeout @findVideoEl, 1000
      return

    @foundVideoEl()

  videoElSelector: ->
    'video'

  noVideoEl: ->
    @video_el.length == 0

  domVideoEl: ->
    return null if @noVideoEl()
    @video_el[0]

  targetEl: ->
    @video_el

  pause: ->
    @domVideoEl().pause()

  play: ->
    @domVideoEl().play()

  seek: (time) ->
    @domVideoEl().currentTime = time

  currentTime: ->
    @domVideoEl().currentTime

  timeUpdated: (e) =>
    return unless @callbacks.timeUpdated
    @callbacks.timeUpdated
      time: @currentTime()

  videoBoxModel: ->
    if @noVideoEl()
      return {
        left: 0
        top: 0
        width: 0
        height: 0
      }

    offset = @video_el.offset()

    {
      left: offset.left
      top: offset.top
      width: @video_el.width()
      height: @video_el.height()
    }

export default Html5Video
