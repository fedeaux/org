export default
  data: ->
    parent_target_component: null

  methods:
    findParentTargetComponent: ->
      parent_target_component = @

      while parent_target_component and parent_target_component.$options.name != 'tats-targets-video'
        parent_target_component = parent_target_component.$parent

      @parent_target_component = parent_target_component

  created: ->
    @findParentTargetComponent()
