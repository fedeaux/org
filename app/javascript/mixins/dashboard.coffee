import DashboardItem from '../lib/dashboard_item'

export default
  data: ->
    dashboard_items: []

  methods:
    addDaysShowDashboardItem: (props = {}) ->
      id = 'day-show-' + props.date.format 'DDMMYYYY'
      props.title = props.date.format 'MMM Do' unless props.title
      @addDashboardItem id, 'days-show', props

    addDashboardItem: (id, vue_component_name, props = {}) ->
      existent_dashboard_item = @findDashboardItem(id).item

      if existent_dashboard_item
        @showDashboardItem id
        return

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

  computed:
    active_dashboard_items_count: ->
      (dashborad_item for dashborad_item in @dashboard_items when dashborad_item.active).length

  mounted: ->
    FedeauxOrg.system.event_bridge.$on 'Day::Show', @addDaysShowDashboardItem

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Day::Show', @addDaysShowDashboardItem
