export default
  methods:
    forceHide: ->
      @$emit 'forceHide'

  computed:
    title: ->
      @dashboard_item.props.title
