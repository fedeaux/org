<template lang="pug">
.logs-timeline
  logs-timeline-ruler
  logs-timeline-item(v-for='log in logs'
                     :key='log.id'
                     :log='log'
                     :style='logStyle(log)'
                     :px_per_block='px_per_block'
                     :minutes_per_block='minutes_per_block')

</template>

<script lang="coffee">
export default
  props:
    px_per_block:
      default: 15

    minutes_per_block:
      default: 30

    logs:
      default: -> []

  computed:
    px_per_minute: ->
      @px_per_block / @minutes_per_block

  methods:
    logStyle: (log) ->
      {
        'background-color': "##{log.loggable.background_color}"
        'border-bottom': "1px solid ##{log.loggable.text_color}"
        'border-left': "4px solid ##{log.loggable.text_color}"
        'border-top': "1px solid ##{log.loggable.text_color}"
        color: "##{log.loggable.text_color}"
        height: @timespanToPx(log)
        top: @logStyleTop(log)
      }

    timespanToPx: (log) ->
      return '1px' unless log.finish
      duration = moment.duration log.finish.diff log.start
      "#{@px_per_minute * duration.asMinutes()}px"

    logStyleTop: (log) ->
      start_of_day = log.start.clone().startOf 'day'
      duration = moment.duration log.start.diff start_of_day
      "#{@px_per_minute * duration.asMinutes()}px"

</script>
