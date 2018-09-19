import DashboardItem from '../lib/dashboard_item'

export default
  data: ->
    dashboard_items: []

  methods:
    addDashboardItem: (id, vue_component_name, props = {}) ->
      container_vue_app = @
      @dashboard_items.push new DashboardItem { id, vue_component_name, container_vue_app, props }

    findDashboardItem: (id) ->
      Helpers.find @dashboard_items, id

    toggleDashboardItem: (dashboard_item_id) ->
      result = @findDashboardItem dashboard_item_id
      return unless result.item
      Vue.set result.item, 'active', !result.item.active

    showDashboardItem: (dashboard_item_id) ->
      result = @findDashboardItem dashboard_item_id
      return unless result.item
      Vue.set result.item, 'active', true

    hideDashboardItem: (dashboard_item_id) ->
      result = @findDashboardItem dashboard_item_id
      return unless result.item
      Vue.set result.item, 'active', false

    setDashboardItemData: (dashboard_item_id, data) ->
      result = @findDashboardItem dashboard_item_id

      if result.index == -1
        console.error "Couldn't find dashboard_item with id #{dashboard_item_id}"
        return

      dashboard_item = result.item

      if data.props
        for name, value of data.props
          Vue.set dashboard_item.props, name, value

      Vue.set dashboard_item, 'active', data.active

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
