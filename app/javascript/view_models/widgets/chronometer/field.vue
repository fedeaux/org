<template lang="pug">
.chronometer-field.ui.fluid.buttons
  .ui.icon.labeled.green.button(@click='play()' v-if='is_idle')
    i.play.icon
    | {{ state_label }}

  .ui.icon.labeled.red.button(@click='stop()' v-if='is_playing')
    i.stop.icon
    | {{ time_label }}

</template>

<script lang="coffee">
export default
  props:
    start:
      required: true

  data: ->
    current_time: null
    current_time_interval: null
    time_label: ''
    start_time: null
    state: 'idle'
    original_document_title: null

  methods:
    play: ->
      @state = 'playing'
      @setup()

    stop: ->
      @state = 'idle'
      clearInterval @current_time_interval if @current_time_interval

    setup: ->
      return unless @start and @start._isAMomentObject
      Vue.set @, 'start_time', @start.clone()
      clearInterval @current_time_interval unless @current_time_interval

      return unless @is_playing

      @setCurrentTime()
      @current_time_interval = setInterval @setCurrentTime, 1000

    setCurrentTime: ->
      return unless @is_playing
      Vue.set @, 'current_time', moment()
      @time_label = @timeLabel()
      FedeauxOrg.system.event_bridge.$emit 'Chronometer::Updated', { @current_time, @time_label }

    timeLabel: ->
      Helpers.formatTimespanAsDuration @start_time, @current_time

    currentDuration: ->
      return 0 unless @start_time and @current_time
      duration = moment.duration @current_time.diff @start_time
      duration.asSeconds()

  computed:
    is_idle: ->
      @state == 'idle'

    is_playing: ->
      @state == 'playing'

    state_label: ->
      voca.titleCase @state

  watch:
    start:
      immediate: true
      handler: ->
        @setup()

  mounted: ->
    @original_document_title = document.title

  beforeDestroy: ->
    @stop()

</script>
