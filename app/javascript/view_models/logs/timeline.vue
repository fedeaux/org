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

    date:
      required: true

  computed:
    px_per_minute: ->
      @px_per_block / @minutes_per_block

  data: ->
    date_sod: null
    date_eod: null

  methods:
    logClass: (log) ->
      return 'logs-timeline-item-event' if @height(log) == '1px'
      'logs-timeline-item-time-block'

    logStyle: (log) ->
      {
        'background-color': "##{log.loggable.background_color}"
        border: "1px solid ##{log.loggable.text_color}"
        color: "##{log.loggable.text_color}"
        height: @height(log) + 'px'
        top: @top(log) + 'px'
        'font-size': @fontSize(log)
      }

    timespanToPx: (start, finish) ->
      start = @date_sod.clone() if start.date() < @date.date()
      finish = @date_eod.clone() if finish.date() > @date.date()

      duration = moment.duration finish.diff start
      @px_per_minute * duration.asMinutes()

    height: (log) ->
      return '1px' unless log.finish
      @timespanToPx log.startUtc(), log.finishUtc()

    top: (log) ->
      return null unless log.start
      return 0 if log.start.date() < @date.date()
      @timespanToPx @date_sod, log.startUtc()

    fontSize: (log) ->
      height = @height log
      return null if height == 0 or height > 20
      return '8px'

  created: ->
    @date_sod = @date.clone().hour(0).minute(0).second(0)
    @date_eod = @date.clone().hour(23).minute(59).second(59)

</script>
