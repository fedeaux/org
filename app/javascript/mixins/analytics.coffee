export default
  data: ->
    trackable_event_names: [
      'TatApp::Tats::New' # User clicks to show the add tat form
      'TatApp::Tats::Created' # User confirms tat creation
      'TatApp::Tats::CancelCreate'

      'TatApp::Tats::ConfirmDestroy' # User clicks to destroy the tat (and sees the "are you sure?" confirmation)
      'TatApp::Tats::CancelDestroy'
      'TatApp::Tats::Destroy'

      'TatApp::Tats::Edit'
      'TatApp::Tats::CancelEdit'
      'TatApp::Tats::Updated'

      'TatApp::Tats::View' # User clicks the "eye" icon to seek video position to tat start time
      'TatApp::Tats::Rendered' # A tat is rendered on the video

      'TatApp::Tats::Contents::Rotated' # User rotates a tat (new or being edited)
      'TatApp::Tats::Contents::Dragged' # User dragged a tat (new or being edited)

      'TatApp::UI::ToogleTatDisplay' # The user clicks the display mode button
      'TatApp::UI::ToggleTatList' # The user clicks the number to show/hide the list of tats
      'TatApp::UI::TatFormDragged' # The user dragged the tat form

      'TatApp::View::Terms'
      'TatApp::View::Privacy'

    ]

    trackable_events: {}

  methods:
    event: (event_name, event_data) ->
      TatApp.lib.analytics.event event_name, event_data

    eventClosure: (event_name) ->
      (event_data = {}) =>
        return if @skipAnalytics event_data
        @event event_name, @adaptEventData event_data

    skipAnalytics: (event_data) ->
      # Looks for 'skip analytics' somewhere in the event_data
      event_data.skip_analytics or
        (event_data.options and event_data.options.skip_analytics)

    adaptEventData: (event_data) ->
      event_data.user_id = @current_user and @current_user.id or undefined

      # detects events with 'tat' and puts its id on the root
      if event_data.tat and event_data.tat.id
        event_data.tat_id = event_data.tat.id

      event_data

  mounted: ->
    # Register ga trackable listeners for vue events.
    for event_name in @trackable_event_names
      @trackable_events[event_name] =
        event_name: event_name
        callback: @eventClosure(event_name)

      TatApp.vue.event_bridge.$on event_name, @trackable_events[event_name].callback

  beforeDestroy: ->
    for event_name, trackable_event of @trackable_events
      TatApp.vue.event_bridge.$off event_name, trackable_event.callback
