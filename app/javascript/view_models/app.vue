<template lang="pug">
#fedeaux-org-app
  logs-form-overlay

  .ui.inverted.menu
    sui-dropdown.item(:text="'View'")
      sui-dropdown-menu
        sui-dropdown-item(@click="toggleDashboardItem('today')") Today
        sui-dropdown-item(@click="toggleAliasedDashboardItem('yesterday')") Yesterday
        sui-dropdown-item(@click="toggleAliasedDashboardItem('last_week')") Last thu
        .divider
        sui-dropdown-item Scratch

    .ui.right.item
      .ui.primary.icon.button(@click='newLog()')
        i.plus.icon

  .ui.grid
    loggables-hierarchy.ui.four.wide.column(v-if='dashboard_items.loggables.active')

    days-show.ui.four.wide.column(v-if='dashboard_items.today.active && current_day'
                                  :date='current_day'
                                  title="Today")

    days-show.ui.four.wide.column(v-if='dashboard_items.other_day.active'
                                  :date='dashboard_items.other_day.props.date'
                                  :title="dashboard_items.other_day.props.title" )

</template>

<script lang="coffee">

import LoggablesResource from '../resources/loggables'
import Store from '../store/index'

export default
  store: Store

  data: ->
    dashboard_items:
      # days
      today: { active: true }
      other_day: { active: false, aliased_id: '', props: {} }

      # loggables
      loggables: { active: true }

  methods:
     newLog: ->
       FedeauxOrg.system.event_bridge.$emit 'Logs::New'

     toggleDashboardItem: (dashboard_item_id) ->
       Vue.set @dashboard_items[dashboard_item_id], 'active', !@dashboard_items[dashboard_item_id].active

     setDashboardItem: (dashboard_item_id, data) ->
       if data.props
         for name, value of data.props
           Vue.set @dashboard_items[dashboard_item_id].props, name, value

       Vue.set @dashboard_items[dashboard_item_id], 'active', data.active

     toggleAliasedDashboardItem: (dashboard_item_id_alias) ->
       if dashboard_item_id_alias == 'yesterday'
         @setDashboardItem 'other_day',
           active: (@dashboard_items.other_day.aliased_id != 'yesterday')
           props:
             date: @current_day.clone().subtract 1, 'day'
             title: 'Yesterday'

       else if dashboard_item_id_alias == 'last_week'
         date = @current_day.clone().subtract 1, 'week'
         @setDashboardItem 'other_day',
           active: (@dashboard_items.other_day.aliased_id != 'last_week')
           props:
             date: date
             title: "Last #{date.format('ddd')}"

  created: ->
    @current_day = moment().startOf 'day'

    @loggables_resource = new LoggablesResource
    @loggables_resource.index @loggablesLoaded

    # @setFormLog

</script>
