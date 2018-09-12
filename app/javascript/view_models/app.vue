<template lang="pug">
#fedeaux-org-app
  .ui.inverted.menu#menu-topperson
    sui-dropdown.item(:text="'View'")
      sui-dropdown-menu
        sui-dropdown-item(v-for='dashboard_item in dashboard_items'
                          v-if='!dashboard_item.props.hide_on_menu'
                          :key='dashboard_item.id') {{ dashboard_item.title() }}

    .ui.right.item
      .ui.primary.icon.button(@click='newLog()')
        i.plus.icon

  .ui.grid#content-wrapper
    component.ui.four.wide.column(v-for='dashboard_item in dashboard_items'
                                  v-if='dashboard_item.active'
                                  :is='dashboard_item.vue_component_name'
                                  :dashboard_item='dashboard_item')

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
    newLog: ->
      console.log 'new Log Menu'

    showLogForm: ->
      console.log 'showLogForm'
      # @setDashboardItemData 'log_form', active: true

    hideLogForm: ->
      # @setDashboardItemData 'log_form', active: false

  created: ->
    @current_day = moment().startOf 'day'
    today_id = 'day-show-' + @current_day.format 'DDMMYYYY'

    yesterday = @current_day.clone().subtract 1, 'day'
    yesterday_id = 'day-show-' + yesterday.format 'DDMMYYYY'

    @addDashboardItem 'loggables-hierarchy', 'loggables-hierarchy', title: 'Loggables'
    @addDashboardItem yesterday_id, 'days-show', { date: yesterday, title: 'Yesterday' }
    @addDashboardItem today_id, 'days-show', { date: @current_day, title: 'Today' }
    @addDashboardItem 'logs-form', 'logs-form', { log_form: null, hide_on_menu: true }

    FedeauxOrg.system.event_bridge.$on 'Logs::New', @showLogForm
    FedeauxOrg.system.event_bridge.$on 'LogForm::Cancel', @hideLogForm

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::New', @showLogForm
    FedeauxOrg.system.event_bridge.$off 'LogForm::Cancel', @hideLogForm

</script>
