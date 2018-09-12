<template lang="pug">
  .days-show
    h1.ui.header
      | {{ title }}

      .ui.sub.header
        | {{ date | weekday_month_monthday }}

    logs-timeline(:logs='logs' v-if='logs.length > 0')

</template>

<script lang="coffee">
import { mapGetters } from 'vuex'

export default
  props:
    dashboard_item:
      required: true

  data: ->
    date: null
    title: ''
    logs: []

  methods:
    loadLogs: ->
                                    # Always pass data around using momentjs
      @$store.dispatch 'logs/load', { date: @date, loaded: @logsChanged }

    logsChanged: (data) ->
      @logs = @$store.getters['logs/onDay'] @date

  created: ->
    # FedeauxOrg.system.event_bridge.$on 'Logs::Added', @logsChanged
    @date = @dashboard_item.props.date
    @title = @dashboard_item.props.title or 'Alface'
    @loadLogs()

  beforeDestroy: ->
    # FedeauxOrg.system.event_bridge.$off 'Logs::Added', @logsChanged

</script>
