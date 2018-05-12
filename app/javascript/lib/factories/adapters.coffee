Adapters = TatApp.lib.adapters

AdapterFactory =
  findAllTargets: ->
    AdapterFactory.adaptToYoutubeNative()
    AdapterFactory.adaptToVevoNative()

  adaptToYoutubeNative: ->
    return unless Adapters.YoutubeNative.isApplicable()
    TatApp.vue.event_bridge.$emit 'TatApp::Adapters::Added', adapters: [new Adapters.YoutubeNative]

  adaptToVevoNative: ->
    return unless Adapters.VevoNative.isApplicable()
    TatApp.vue.event_bridge.$emit 'TatApp::Adapters::Added', adapters: [new Adapters.VevoNative]

  createFromYoutubeApi: (target_id, player_options_or_video_id = {}) ->
    return unless $("##{target_id}").length > 0
    TatApp.vue.event_bridge.$emit 'TatApp::Adapters::Added', adapters: [new Adapters.YoutubeApi target_id, player_options_or_video_id]

export default AdapterFactory
