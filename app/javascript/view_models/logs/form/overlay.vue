<template lang="pug">
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
      @log = new Log data.attributes or {}
      @$nextTick @show

  created: ->
    FedeauxOrg.system.event_bridge.$on 'Logs::New', @newLog

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::New', @newLog
</script>
