<template lang="pug">
.logs-item-menu.ui.vertical.menu(@mouseleave='forceHide()')
  .item(v-if='confirming_destroy')
    .ui.message Really delete?
    .ui.mini.fluid.buttons
      .ui.red.button(@click='destroyLog()') Delete
      .ui.basic.green.button(@click='confirming_destroy = false') Cancel

  template(v-else)
    a.item(@click='editLog()')
      i.edit.icon
      | Edit this log

    a.item(@click='confirming_destroy = true')
      i.trash.icon
      | Delete this log

    a.item(@click='showLoggableStory()')
      i.eye.icon
      | View "{{ log.loggable.name }}" story.

    .item(v-if='log && log.description')
      logs-item-description(:log='log')

</template>

<script lang="coffee">
export default
  props: ['log']

  data: ->
    confirming_destroy: false

  methods:
    forceHide: ->
      @$emit 'hide'

    editLog: ->
      FedeauxOrg.system.event_bridge.$emit 'Logs::Edit', { @log }
      @forceHide()

    destroyLog: ->
      @$store.dispatch 'logs/destroy', @log
      @forceHide()
      @confirming_destroy = false

    showLoggableStory: ->
      @forceHide()
      FedeauxOrg.system.event_bridge.$emit 'Loggables::Show', { path_ids: @log.loggable.path_ids }

  mounted: ->
    FedeauxOrg.system.event_bridge.$emit 'Logs::TimelineMenuItemShown'
    FedeauxOrg.system.event_bridge.$on 'Logs::TimelineMenuItemShown', @forceHide

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::TimelineMenuItemShown', @forceHide

</script>
