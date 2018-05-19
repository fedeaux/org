<template lang="pug">
.loggables-hierarchy-item
  .loggables-hierarchy-item-name(:style='hierarchy_item_style')
    | {{ loggable.name }}

    .loggables-hierarchy-item-actions
      i.eye.icon(@click='view()')
      i.plus.icon(@click='add()')

  loggables-hierarchy-item(v-for='child in loggable.children' :loggable='child' :key='child.id')

</template>

<script lang="coffee">
export default
  props:
    loggable:
      required: true

  methods:
    view: ->

    add: ->
      FedeauxOrg.system.event_bridge.$emit 'Logs::New', attributes: { loggable_id: @loggable.id }

  computed:
    hierarchy_item_style: ->
      {
        'background-color': "##{@loggable.background_color}"
        'border': "thin solid ##{@loggable.text_color}"
        'color': "##{@loggable.text_color}"
      }

</script>
