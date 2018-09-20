<template lang="pug">
.loggables-show
  dashboard-item-header(v-if='loggable' :title="loggable.name")
  logs-list(:logs='logs' v-if='logs.length > 0')

</template>

<script lang="coffee">

import DashboardItemMixin from '../../mixins/dashboard_item'

export default
  mixins: [ DashboardItemMixin ]

  props:
    dashboard_item:
      required: true

  data: ->
    loggable: null
    logs: []

  methods:
    loadLogs: ->
                                    # Always pass data around using momentjs
      @$store.dispatch 'logs/load', { loggable_id: @loggable.id, loaded: @logsChanged }

    logsChanged: (data) ->
      @logs = @$store.getters['logs/byLoggableId'] @loggable.id

  created: ->
    FedeauxOrg.system.event_bridge.$on 'Logs::Changed', @logsChanged
    @loggable = @$store.getters['loggables/byPathIds'] @dashboard_item.props.path_ids
    @loadLogs()

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::Changed', @logsChanged

</script>
