<template lang="pug">
  sui-modal(v-model="open")
    .content
      logs-form(:log='log' v-if='log && open' ref='form')

    .actions
      .ui.basic.button(@click='hide()') Cancel
      .ui.primary.button(@click='save()') Save
</template>

<script lang="coffee">

import Log from '../../../models/log'

export default
  data: ->
    open: false
    log: {}

  methods:
    show: ->
      @open = true

    hide: ->
      @open = false

    save: ->
      @$refs.form.save()

    newLog: (data) ->
      @show()
      @log = new Log data.attributes or {}

  created: ->
    FedeauxOrg.system.event_bridge.$on 'Logs::New', @newLog

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::New', @newLog
</script>
