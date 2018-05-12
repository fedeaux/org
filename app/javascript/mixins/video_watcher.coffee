export default
  data: ->
    current_video_time: 0
    video_watcher: null

  methods:
    videoWatcherCallbacks: ->
      {
        timeUpdated: @videoTimeUpdated
        installError: @videoWatcherError
        installSuccess: @videoWatcherSuccess
      }

    videoWatcherError: (data) ->
      TatApp.vue.event_bridge.$emit 'TatApp::Deactivate'

    videoWatcherSuccess: ->
      TatApp.vue.event_bridge.$emit 'TatApp::Activate'

    videoTimeUpdated: (data) ->
      @current_video_time = data.time

    viewTat: (data) ->
      options = _.extend { pause: false }, (data.options || {})

      @video_watcher.seek data.tat.target.start
      @video_watcher.pause() if options.pause
