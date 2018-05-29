<template lang="pug">
  .days-show
    h1.ui.header
      | {{ title }}

      .ui.sub.header
        | {{ date | weekday_month_monthday }}

    logs-timeline(:logs='logs' v-if='logs.length > 0')

</template>

<script lang="coffee">
import LogsResource from '../../resources/logs'

export default
  props:
    date:
      required: true

    title:
      default: 'Day'

  data: ->
    logs: []

  methods:
    checkIfIsGoodHere: (data) ->
      # check if data.log would be part of this days @logs

    loadLogs: ->
      res = new LogsResource
      res.index @logsLoaded, { date: @date.utc().format() }

    logsLoaded: (data) ->
      @logs = data.logs

  created: ->
    FedeauxOrg.system.event_bridge.$on 'Logs::Added', @checkIfIsGoodHere
    @loadLogs()

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::Added', @checkIfIsGoodHere

</script>
