<template lang="pug">
.logs-timeline
  logs-timeline-ruler(:px_per_block='px_per_block' :minutes_per_block='minutes_per_block')
  logs-timeline-item(v-for='log in logs'
                     :key='log.id'
                     :log='log'
                     :style='logStyle(log)'
                     :class='logClass(log)'
                     :px_per_block='px_per_block'
                     :minutes_per_block='minutes_per_block')

</template>

<script lang="coffee">
export default
  props:
    px_per_block:
      default: 16

    minutes_per_block:
      default: 30

    logs:
      default: -> []

  computed:
    px_per_minute: ->
      @px_per_block / @minutes_per_block

  methods:
    logClass: (log) ->
      return 'logs-timeline-item-event' if @timespanToPx(log) == 0
      'logs-timeline-item-time-block'

    logStyle: (log) ->
      {
        'background-color': "##{log.loggable.background_color}"
        border: "1px solid ##{log.loggable.text_color}"
        color: "##{log.loggable.text_color}"
        height: @timespanToPx(log) + 'px'
        top: @logStyleTop(log) + 'px'
        'font-size': @logStyleFontSize(log)
      }

    timespanToPx: (log) ->
      return '1px' unless log.finish
      duration = moment.duration log.finish.diff log.start
      @px_per_minute * duration.asMinutes()

    logStyleTop: (log) ->
      return null unless log.start
      start_of_day = log.start.clone().startOf 'day'
      duration = moment.duration log.start.diff start_of_day
      @px_per_minute * duration.asMinutes()

    logStyleFontSize: (log) ->
      height = @timespanToPx log
      return null if height == 0 or height > 20
      return '8px'

</script>
