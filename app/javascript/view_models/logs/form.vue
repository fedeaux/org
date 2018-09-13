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
          datetime-picker(v-model='log.start')

        .field
          label Finish
          datetime-picker(v-model='log.finish')

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
    duration_display: ''
    duration: null

    log: null

  methods:
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

  watch:
    duration: ->
      @duration_display = "#{@totalDuration()}min"

  mounted: ->
    FedeauxOrg.system.event_bridge.$on 'Logs::New', @newLog
    FedeauxOrg.system.event_bridge.$on 'Logs::Edit', @editLog
    FedeauxOrg.system.event_bridge.$on 'Logs::Changed', @cancel

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::New', @newLog
    FedeauxOrg.system.event_bridge.$off 'Logs::Edit', @editLog
    FedeauxOrg.system.event_bridge.$off 'Logs::Changed', @cancel

</script>
