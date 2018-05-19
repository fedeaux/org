<template lang="pug">
.loggables-hierarchy-item(:style='hierarchy_item_style')
  | {{ loggable.name }}
</template>

<script lang="coffee">
export default
  props:
    loggable:
      required: true

  computed:
    hierarchy_item_style: ->
      {
        'background-color': "##{@loggable.background_color}"
        'border': "thin solid ##{@loggable.text_color}"
        'color': "##{@loggable.text_color}"
      }

</script>
