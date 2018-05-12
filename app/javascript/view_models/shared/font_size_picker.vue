<template lang="pug">
.font-size-picker
  .font-size-picker-slider
</template>

<script lang="coffee">
# Heads up! This picker interprets the font-size as a number between 0.02 and 0.08 (2 to 8% of containers height)
export default
  props: ['value']

  methods:
    initSlider: ->
      $('.font-size-picker-slider', @$el).slider
        value: @value
        min: 0.02
        max: 0.08
        step: 0.005
        slide: @slide

    slide: (event, ui)->
      @$emit 'input', ui.value

  mounted: ->
    @$nextTick @initSlider
</script>
