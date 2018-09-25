<template lang="pug">
.days-show
  dashboard-item-header(:title="title" :sub_title="sub_title")
  days-navigator(:date='date' v-if='date')
  br
  br
  logs-timeline(:logs='logs' v-if='logs.length > 0' :date='date')

</template>

<script lang="coffee">

import DashboardItemMixin from '../../mixins/dashboard_item'

export default
  mixins: [ DashboardItemMixin ]

  props:
    dashboard_item:
      required: true

  data: ->
    date: null
    logs: []

  computed:
    sub_title: ->
      @date.format 'ddd, MMM Do'

  methods:
    loadLogs: ->
                                    # Always pass data around using momentjs
      @$store.dispatch 'logs/load', { date: @date, loaded: @logsChanged }

    logsChanged: (data) ->
      @logs = @$store.getters['logs/onDay'] @date

  created: ->
    FedeauxOrg.system.event_bridge.$on 'Logs::Changed', @logsChanged
    @date = @dashboard_item.props.date
    @loadLogs()

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::Changed', @logsChanged

</script>
