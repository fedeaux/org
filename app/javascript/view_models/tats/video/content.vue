<template lang="pug">
.tats-video-content-outer-container(:class='content_outer_container_class' :style='content_outer_container_style' @mouseover="mouse_over = true" @mouseleave="mouse_over = false")

  .tats-video-content-actions(v-if='is_in_form')
    .drag-handle.tats-video-content-action-bottom-right.position-drag-handle
      i.fa.fa-arrows

  .tats-video-content-inner-container(:style='content_inner_container_style')
    .drag-handle.tats-video-content-action-top-right.rotation-drag-handle(v-if='is_in_form')
      i.fa.fa-repeat

    .tats-video-content
      | {{ content.content }}

</template>

<script lang="coffee">

import RotationPicker from '../../../support/rotation_picker'

export default
  props: ['tat', 'content', 'is_in_form', 'there_is_some_in_form', 'display']

  data: ->
    mouse_over: false

  mixins: TatApp.import('vue.mixins': ['parent_target_component_accessor'])

  methods:
    jel: ->
      $ @$el

    dragged: (event, ui) ->
      denormalized_spacial_properties = @jel().offset()
      denormalized_spacial_properties['font-size'] = parseInt @jel().css 'font-size' # wtf, don't do this
      @content.normalizeSpacialProperties denormalized_spacial_properties, @parent_target_component.video_watcher.videoBoxModel()
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::Contents::Dragged', { @tat }

    rotated: (value) ->
      transformations = @content.transformationProperties()
      transformations.rotate = value
      @content.setProperty 'transformations', transformations
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::Contents::Rotated', { @tat }

    # smells like code smell, this should be part of tats-video-form
    setDraggability: ->
      jel = @jel()
      draggable_installed = jel.data 'ui-draggable'

      if @is_in_form
        if draggable_installed
          jel.draggable 'enable'
        else
          jel.draggable
            stop: @dragged
            handle: '.position-drag-handle'
            iframeFix: true

      else
        return unless draggable_installed
        jel.draggable 'disable'

    # smells like code smell, this should be part of tats-video-form
    installRotationPicker: ->
      new RotationPicker $('.tats-video-content-inner-container', @$el), '.rotation-drag-handle', @rotated

    containerBoxModel: ->
      @parent_target_component.video_watcher.videoBoxModel()

  computed:
    content_outer_container_class: ->
      classes = []

      if @is_in_form
        classes.push 'tats-video-content-is-in-form'

      else if @there_is_some_in_form
        classes.push 'tats-video-content-there-is-some-in-form'

      if @display == 'compact' and !@mouse_over
        classes.push 'tats-video-content-display-compact'

      classes.join ' '

    content_outer_container_style: ->
      @content.denormalizedOuterContainerStyle @containerBoxModel()

    content_inner_container_style: ->
      @content.denormalizedInnerContainerStyle @containerBoxModel()

  watch:
    is_in_form: ->
      return unless @is_in_form

      @$nextTick ->
        @setDraggability()
        @installRotationPicker()

  mounted: ->
    return unless @is_in_form
    @setDraggability()
    @installRotationPicker()

</script>
