<template lang="pug">
.logs-statistics
  dashboard-item-header(:title="'Statistics'" :sub_title="'From the last 21 days'")

  template(v-for='statistics in statistics_groups' v-if='statistics_groups && statistics_groups.length > 0')
    h3.ui.title {{ statistics.title }}
    table.ui.very.basic.small.striped.table
      tr(v-for='statistic in statistics.statistics')
        td {{ statistic.label }}
        td {{ statistic.value }}
</template>

<script lang="coffee">

import DashboardItemMixin from '../../mixins/dashboard_item'

export default
  mixins: [ DashboardItemMixin ]

  data: ->
    statistics_groups: []
    statistics_url: null

  methods:
    loadStatistics: ->
      $.ajax
        url: @statistics_url
        complete: @statisticsLoaded

    statisticsLoaded: (response) ->
      @statistics_groups = response.responseJSON

  created: ->
    @statistics_url = "#{FedeauxOrg.config.api_url}/statistics"
    @loadStatistics()

</script>
