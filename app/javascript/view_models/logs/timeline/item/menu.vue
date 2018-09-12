<template lang="pug">
.logs-timeline-item-menu.ui.vertical.menu(@mouseleave='forceHide()')
  .item(v-if='confirming_destroy')
    .ui.message Really delete?
    .ui.fluid.buttons
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
      console.log 'show', @log.loggable
      @forceHide()

  mounted: ->
    FedeauxOrg.system.event_bridge.$emit 'Logs::TimelineMenuItemShown'
    FedeauxOrg.system.event_bridge.$on 'Logs::TimelineMenuItemShown', @forceHide
    console.log 'confirming_destroy', @confirming_destroy

  beforeDestroy: ->
    FedeauxOrg.system.event_bridge.$off 'Logs::TimelineMenuItemShown', @forceHide

</script>
