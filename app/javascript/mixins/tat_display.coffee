export default
  data: ->
    display: 'default' # default, compact, none

  methods:
    toggleDisplay: ->
      return @display = 'compact' if @display == 'default'
      return @display = 'none' if @display == 'compact'
      @display = 'default'

    ensureDefaultDisplay: ->
      @display = 'default'

  watch:
    display: ->
      TatApp.vue.event_bridge.$emit 'TatApp::UI::ToogleTatDisplay', { @display }

  computed:
    visible: ->
      @display in ['compact', 'default']
