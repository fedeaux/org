<template lang="pug">
#fedeaux-org-app
  .ui.fixed.inverted.menu#menu-topperson
    sui-dropdown.item(:text="'View'")
      sui-dropdown-menu
        sui-dropdown-item(v-for='dashboard_item in dashboard_items'
                          v-if='!dashboard_item.props.hide_on_menu'
                          :key='dashboard_item.id') {{ dashboard_item.title() }}

    .ui.right.item
      .ui.primary.icon.button(@click='newLog()')
        i.plus.icon

  #content-wrapper(:class='content_wrapper_class')
    .ui.column.dashboard-item-wrapper(v-for='dashboard_item in dashboard_items'
                                      v-show='dashboard_item.active')

      component.dashboard-item(:is='dashboard_item.vue_component_name'
                               :dashboard_item='dashboard_item'
                               @forceHide='hideDashboardItem(dashboard_item.id)'
                               @forceShow='showDashboardItem(dashboard_item.id)')

</template>

<script lang="coffee">

import LoggablesResource from '../resources/loggables'
import Store from '../store/index'
import DashboardItem from '../lib/dashboard_item'
import DashboardMixin from '../mixins/dashboard'

export default
  mixins: [DashboardMixin]

  store: Store

  methods:
    addLoggableShowDashboardItem: (data) ->
      @addDashboardItem "loggables-show-#{data.path_ids}", 'loggables-show', { path_ids: data.path_ids }

  computed:
    content_wrapper_class: ->
      columns = if @active_dashboard_items_count <= 4
                  'four'

                else if @active_dashboard_items_count == 5
                  'five'

                else if @active_dashboard_items_count == 6
                  'six'

                else
                  'seven'

      "ui #{columns} column grid"

  created: ->
    @current_day = moment().startOf 'day'
    @addDashboardItem 'loggables-hierarchy', 'loggables-hierarchy', title: 'Loggables'
    @addDashboardItem 'logs-form', 'logs-form', { log_form: null, hide_on_menu: true }

    one_week_ago = @current_day.clone().subtract 1, 'week'

    @addDaysShowDashboardItem { date: @current_day, title: 'Today' }
    @addDaysShowDashboardItem { date: @current_day.clone().subtract(1, 'day'), title: 'Yesterday' }
    @addDaysShowDashboardItem { date: one_week_ago , title: "Last #{one_week_ago.format('dddd')}" }

    FedeauxOrg.system.event_bridge.$on 'Days::Show', @addDaysShowDashboardItem
    FedeauxOrg.system.event_bridge.$on 'Loggables::Show', @addLoggableShowDashboardItem

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Days::Show', @addDaysShowDashboardItem
    FedeauxOrg.system.event_bridge.$off 'Loggables::Show', @addLoggableShowDashboardItem

</script>
