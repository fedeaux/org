import BaseVideo from './base_video'

class YoutubeApiVideo extends BaseVideo
  constructor: (@target_id, @callbacks) ->
    @callbacks.installSuccess()

  iFrameElement: ->
    $ "##{@target_id}"

  targetEl: ->
    @iFrameElement()

  pause: ->
    return unless @yt_api_instance
    @yt_api_instance.pauseVideo()

  play: ->
    return unless @yt_api_instance
    @yt_api_instance.playVideo()

  seek: (time) ->
    return unless @yt_api_instance
    @yt_api_instance.seekTo time

  currentTime: ->
    return unless @yt_api_instance
    @yt_api_instance.getCurrentTime()

  timeUpdated: =>
    # TODO: Unclear division of responsibilities between TatApp.Adapters.YoutubeApi and TatApp.Watchers.YoutubeApiVideo
    # This function is unused
    @callbacks.timeUpdated
      time: @currentTime()

  videoBoxModel: ->
    iframe = @iFrameElement()
    offset = iframe.offset()

    {
      left: offset.left
      top: offset.top
      width: iframe.width()
      height: iframe.height()
    }

export default YoutubeApiVideo
