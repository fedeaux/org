import YoutubeVideo from './youtube_video'
import YoutubeApiVideoWatcher from '../watchers/youtube_api_video'

class YoutubeApi extends YoutubeVideo
  constructor: (@target_id, player_options_or_video_id) ->
    super()
    @yt_api_instance = null
    @current_time_fetcher_timeout = null
    @current_time_fetcher_timeout_time = 100 #milliseconds

    @resolveOptions player_options_or_video_id

    # TODO check if already required to allow multiple embeds
    @installOnYouTubeIframeAPIReady()
    @requireYoutubeApi()

  instantiateVideoWatcher: (callbacks) ->
    @videoTimeUpdated = callbacks.timeUpdated
    new YoutubeApiVideoWatcher @target_id, callbacks

  targetIdentifier: ->
    @player_options.videoId

  resolveOptions: (player_options_or_video_id) ->
    @player_options = @defaultPlayerOptions()

    if _.isString player_options_or_video_id
      @player_options.videoId = player_options_or_video_id

    else if _.isObject player_options_or_video_id
      @player_options = _.extend @player_options, player_options_or_video_id

  defaultPlayerOptions: ->
    events:
      onReady: =>
        # Player Ready

      onStateChange: (event) =>
        switch event.data
          when YT.PlayerState.PLAYING then @onVideoPlay()
          when YT.PlayerState.PAUSED then @onVideoPaused()

    playerVars:
      rel: 0

  onVideoPlay: ->
    TatApp.vue.event_bridge.$emit 'TatApp::Activate'
    @current_time_fetcher_timeout = setInterval @reportTime, @current_time_fetcher_timeout_time

  reportTime: =>
    # TODO: Unclear division of responsibilities between TatApp.Adapters.YoutubeApi and TatApp.Watchers.YoutubeApiVideo
    @videoTimeUpdated
      time: @yt_api_instance.getCurrentTime()

  onVideoPaused: ->
    clearInterval @current_time_fetcher_timeout

  requireYoutubeApi: ->
    # TODO check if already required
    tag = document.createElement 'script'
    tag.src = 'https://www.youtube.com/iframe_api'
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  installOnYouTubeIframeAPIReady: ->
    window.onYouTubeIframeAPIReady = =>
      @yt_api_instance = new YT.Player @target_id, @player_options
      @video_watcher.yt_api_instance = @yt_api_instance

export default YoutubeApi
