<template lang="pug">
#fedeaux-org-app
  .ui.inverted.menu
    sui-dropdown.item(:text="'View'")
      sui-dropdown-menu
        sui-dropdown-item(@click="toggleDashboardItem('today')") Today
        sui-dropdown-item(@click="toggleAliasedDashboardItem('yesterday')") Yesterday
        sui-dropdown-item(@click="toggleAliasedDashboardItem('last_week')") Last thu
        .divider
        sui-dropdown-item Scratch

  .ui.grid
    //- component.ui.four.wide.column(:is='item.vue_component_name' v-for='item in dashboard_items' :key='item.id')

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
     toggleDashboardItem: (dashboard_item_id) ->
       Vue.set @[dashboard_item_id], 'active', !@[dashboard_item_id].active

     toggleAliasedDashboardItem: (dashboard_item_id_alias) ->
       if dashboard_item_id_alias == 'yesterday'
         if @dashboard_items.other_day.aliased_id == 'yesterday'
           Vue.set @dashboard_items.other_day, 'active', false

         else
           Vue.set @dashboard_items.other_day, 'active', true
           Vue.set @dashboard_items.other_day.props, 'date', @current_day.clone().subtract 1, 'day'
           Vue.set @dashboard_items.other_day.props, 'title', 'Yesterday'

       else if dashboard_item_id_alias == 'last_week'
         if @dashboard_items.other_day.aliased_id == 'last_week'
           Vue.set @dashboard_items.other_day, 'active', false

         else
           date = @current_day.clone().subtract 1, 'week'

           Vue.set @dashboard_items.other_day, 'active', true
           Vue.set @dashboard_items.other_day.props, 'date', date
           Vue.set @dashboard_items.other_day.props, 'title', "Last #{date.format('ddd')}"

  created: ->
    @current_day = moment().startOf 'day'

    @loggables_resource = new LoggablesResource
    @loggables_resource.index @loggablesLoaded

    # for item_name in ['loggables', 'today']# 'yesterday', 'last_week']
    #   klass = require("../dashboard/items/#{item_name}").default
    #   item = new klass
    #   @dashboard_items.push item

</script>
