<template lang="pug">
.tats-video-form-wrapper(v-if='tat')
  .ui.fluid.pink.large.label.form-drag-handle Drag here to reposition

  .ui.form
    component(:is='currentTatContentFormComponentName()' :tat_content='tat_content_form')

    .ui.fluid.buttons
      .ui.basic.button(@click='cancel()')
        | Cancel

      .ui.primary.button(@click='save()')
        | Save

    terms-and-privacy-links

</template>

<script lang="coffee">
export default
  props: ['tat']

  mixins: TatApp.import('vue.mixins': ['parent_target_component_accessor'])

  data: ->
    tat_content_form: null

  methods:
    tatLoaded: ->
      # Update when tat allows more than one content
      @tat_content_form = @tat.contents[0]
      @$nextTick @formShown

    formShown: ->
      @positionForm()

    cancel: ->
      @$emit 'cancel'

    save: ->
      @$emit 'save'

    currentTatContentFormComponentName: ->
      return null unless @tat_content_form
      "tats-content-form-#{@tat_content_form.content_type}"

    positionForm: ->
      # TODO a better positioner to always show the menu in a proper place.
      # See only-girl-stuff/app/assets/javascripts/selected_area_controls.coffee
      video_box_model = @parent_target_component.video_watcher.videoBoxModel()
      form = $ @$el

      form.css 'left', (video_box_model.left + (video_box_model.width - form.width())/2) + 'px'
      form.css 'top', (video_box_model.top + video_box_model.height - form.height() - 30)+'px'
      form.draggable
        handle: '.form-drag-handle'
        iframeFix: true
        stop: =>
          TatApp.vue.event_bridge.$emit 'TatApp::UI::TatFormDragged'

  watch:
    tat: ->
      @tatLoaded() if @tat

</script>
