<template lang="pug">
  .logs-form
    h2.ui.header
      | Log Form
      .ui.sub.header
        | {{ duration_display }}

    .ui.form
      .field
        loggables-select(v-model='log.loggable_id')

      .two.fields
        .field
          label Start
          input#start-input(type='text' v-model='start_display')

        .field
          label Finish
          input(type='text' v-model='finish_display')

      .field
        label Description
        textarea(v-model='log.description')

</template>

<script lang="coffee">
export default
  props: ['log']

  data: ->
    start_display: ''
    finish_display: ''
    current_time: null
    current_time_interval: null
    duration_display: ''
    duration: null

  methods:
    updateCurrentTime: ->
      @current_time = moment()
      one_minute_ago = @current_time.clone().subtract 1, 'minute'
      return if @finish_display == '' or @finish_display != one_minute_ago.format('HH:mm')
      @finish_display = @current_time.format 'HH:mm'

    parseTime: (timestamp) ->
      date = moment timestamp, 'HH:mm'
      # if invalid try with year etc
      return null unless date.isValid()
      date

    roundMoment: (date) ->
      minutes = date.minutes()
      date.minutes minutes - (minutes % 5)
      date

    updateDuration: ->
      return unless @log.start and @log.start.isValid() and @log.finish and @log.finish.isValid()
      @duration = moment.duration @log.finish.diff @log.start

    save: ->
      return unless @log.loggable_id and @log.start
      @$store.dispatch 'logs.save', @log

    totalDuration: ->
      return 0 unless @duration and @duration.isValid()
      @duration.hours() * 60 + @duration.minutes()

  watch:
    start_display: ->
      date = @parseTime @start_display

      if date and date.isValid()
        @log.start = date

      @updateDuration()

    finish_display: ->
      date = @parseTime @finish_display

      if date and date.isValid()
        @log.finish = date

      @updateDuration()

    duration: ->
      @duration_display = "#{@totalDuration()}min"

  mounted: ->
    @updateCurrentTime()

    @$nextTick ->
      @current_time_interval = setInterval @updateCurrentTime, 5000
      rounded_current_time = @roundMoment @current_time
      @start_display = rounded_current_time.format 'HH:mm'
      @finish_display = rounded_current_time.format 'HH:mm'

      $('#start-input', @$el).focus()
</script>
