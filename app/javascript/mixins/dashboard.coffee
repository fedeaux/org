import DashboardItem from '../lib/dashboard_item'

export default
  data: ->
    dashboard_items: []
      # days
      # today: { active: true }
      # other_day: { active: false, aliased_id: '', props: {} }
      # days: {}

      # # loggables
      # loggables: { active: true }

      # # logs
      # log_form: { active: false }


  methods:
    addDashboardItem: (id, vue_component_name, props = {}) ->
      container_vue_app = @
      @dashboard_items.push new DashboardItem { id, vue_component_name, container_vue_app, props }

    findDashboardItem: (id) ->
      Helpers.find @dashboard_items, id

    toggleDashboardItem: (dashboard_item_id) ->
      Vue.set @dashboard_items[dashboard_item_id], 'active', !@dashboard_items[dashboard_item_id].active

    setDashboardItemData: (dashboard_item_id, data) ->
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
