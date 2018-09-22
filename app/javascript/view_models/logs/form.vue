<template lang="pug">
  .logs-form(v-if='log')
    h1.ui.header
      | Log Form
      .ui.sub.header
        | {{ duration_display }}

    .ui.form
      .field
        loggables-select(v-model='log.loggable_id' ref="loggablesSelect")

      .two.fields
        .field
          label Start
          datetime-picker(v-model='log.start')

        .field
          label Finish
          datetime-picker(v-model='log.finish')

      .field(v-if='log && log.start && log.loggable')
        chronometer-field(:start='log.start')

      .field
        label Description
        textarea(v-model='log.description')

      .ui.fluid.small.buttons
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
    duration_display: ''
    duration: null

    time_label: ''
    log: null

  methods:
    chronometerCurrentTimeUpdated: (data) ->
      return unless @log
      Vue.set @log, 'finish', data.current_time
      @time_label = data.time_label
      @updatePageTitle()

    newLog: (data = {}) ->
      @log = new Log data.attributes or {}

    editLog: (data) ->
      @log = data.log

    save: ->
      return unless @log.loggable_id and @log.start
      @$store.dispatch 'logs/save', @log

    cancel: ->
      @log = null
      FedeauxOrg.system.event_bridge.$emit 'LogForm::Cancel'

    totalDuration: ->
      return 0 unless @duration and @duration.isValid()
      @duration.hours() * 60 + @duration.minutes()

    updatePageTitle: ->
      document.title = "#{@time_label} - #{@log.loggable.name}"

  watch:
    duration: ->
      @duration_display = "#{@totalDuration()}min"

    log:
      immediate: true
      handler: ->
        if @log
          @$emit 'forceShow'
          return

        @$emit 'forceHide'

    'log.loggable_id': ->
      return unless @log
      @log.loggable = @$store.getters['loggables/find'](@log.loggable_id).item
      @updatePageTitle()

  mounted: ->
    FedeauxOrg.system.event_bridge.$on 'Logs::New', @newLog
    FedeauxOrg.system.event_bridge.$on 'Logs::Edit', @editLog
    FedeauxOrg.system.event_bridge.$on 'Logs::Changed', @cancel
    FedeauxOrg.system.event_bridge.$on 'Chronometer::Updated', @chronometerCurrentTimeUpdated

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::New', @newLog
    FedeauxOrg.system.event_bridge.$off 'Logs::Edit', @editLog
    FedeauxOrg.system.event_bridge.$off 'Logs::Changed', @cancel
    FedeauxOrg.system.event_bridge.$off 'Chronometer::Updated', @chronometerCurrentTimeUpdated

</script>
