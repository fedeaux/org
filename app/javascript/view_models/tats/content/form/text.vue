<template lang="pug">
.tats-content-form-wrapper.field(v-if='tat_content')
  .field
    label Text
    input.tats-content-text-input(type='text' v-model='tat_content.content')

  .field
    label Font Size
    font-size-picker(v-model='font_size')

  .field
    label Text Color
    compact-picker(v-model="text_color")

  .field
    label Background Color
    compact-picker(v-model="background_color")
</template>

<script lang="coffee">

export default
  props: ['tat_content']

  data: ->
    # Update when tat allows more than one content
    background_color: {}
    text_color: {}
    font_size: null

  methods:
    tatContentLoaded: ->
      @text_color = { hex: @tat_content.properties.css.color }
      @background_color = { hex: @tat_content.properties.css['background-color'] }
      @font_size = @tat_content.properties.normalized['font-size']

      @$nextTick @formShown

    formShown: ->
      @installEmojiPicker()

    installEmojiPicker: ->
      $('.tats-content-text-input', @$el).emojiPicker
        button: false
        position: 'left'

    setTatContentProperty: (namespace, name, value) ->
      properties = @tat_content.properties
      properties[namespace][name] = value
      Vue.set @tat_content, 'properties', properties

  components:
    'compact-picker': VueColor.Compact

  watch:
    text_color: ->
      @setTatContentProperty 'css', 'color', @text_color.hex

    background_color: ->
      @setTatContentProperty 'css', 'background-color', @background_color.hex

    font_size: ->
      @setTatContentProperty 'normalized', 'font-size', @font_size

  mounted: ->
    @tatContentLoaded()

</script>
