<template lang="pug">
  .logs-form(v-if='log')
    h1.ui.header
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

      .ui.fluid.buttons
        .ui.primary.labeled.icon.button(@click='save')
          | Save
          i.save.icon

        .ui.white.right.labeled.icon.button(@click='cancel')
          i.cancel.icon
          | Cancel

</template>

<script lang="coffee">
import Log from '../../models/log'

export default
  data: ->
    start_display: ''
    finish_display: ''
    current_time: null
    current_time_interval: null
    duration_display: ''
    duration: null
    log: null

  methods:
    newLog: (data = {}) ->
      @log = new Log data.attributes or {}

    editLog: (data) ->
      @log = data.log

    updateCurrentTime: ->
      @current_time = moment()
      one_minute_ago = @current_time.clone().subtract 1, 'minute'
      return if @finish_display == '' or @finish_display != one_minute_ago.format('HH:mm')
      @finish_display = @current_time.format 'HH:mm'

    parseTime: (timestamp) ->
      return null if timestamp.length == 0
      console.log 'parseTime', timestamp
      date = moment timestamp, 'HH:mm'
      # if invalid try with year etc
      return null unless date.isValid()
      date

    roundMoment: (date) ->
      minutes = date.minutes()
      date.minutes minutes - (minutes % 5)
      date

    updateDuration: ->
      return unless @log and @log.start and @log.start.isValid() and @log.finish and @log.finish.isValid()
      @duration = moment.duration @log.finish.diff @log.start

    save: ->
      return unless @log.loggable_id and @log.start
      @$store.dispatch 'logs/save', @log

    cancel: ->
      FedeauxOrg.system.event_bridge.$emit 'LogForm::Cancel'

    totalDuration: ->
      return 0 unless @duration and @duration.isValid()
      @duration.hours() * 60 + @duration.minutes()

    setFromDisplay: (field) ->
      date = @parseTime @["#{field}_display"]

      if date and date.isValid()
        @log[field] = date
      else
        @log[field] = null

      @updateDuration()

  watch:
    start_display: ->
      return unless @log
      @setFromDisplay 'start'

    finish_display: ->
      return unless @log
      @setFromDisplay 'finish'

    duration: ->
      @duration_display = "#{@totalDuration()}min"

    log: ->
      return unless @log
      @start_display = @log.start.format 'HH:mm' if @log.start
      @finish_display = @log.finish.format 'HH:mm' if @log.finish
      @setFromDisplay 'start'
      @setFromDisplay 'finish'

  mounted: ->
    @updateCurrentTime()
    FedeauxOrg.system.event_bridge.$on 'Logs::New', @newLog
    FedeauxOrg.system.event_bridge.$on 'Logs::Edit', @editLog

    @$nextTick =>
      if !@log or @log.isNewRecord()
        @current_time_interval = setInterval @updateCurrentTime, 5000
        rounded_current_time = @roundMoment @current_time
        @start_display = rounded_current_time.format 'HH:mm'
        @finish_display = rounded_current_time.format 'HH:mm'

      else
        # @start_display = @log.start.format 'HH:mm'
        # @finish_display = @log.finish.format 'HH:mm'

      $('#start-input', @$el).focus()

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::New', @newLog
    FedeauxOrg.system.event_bridge.$off 'Logs::Edit', @editLog

</script>
