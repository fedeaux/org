<template lang="pug">
.loggables-hierarchy-item
  .loggables-hierarchy-item-name(:style='hierarchy_item_style')
    | {{ loggable.name }}

    .loggables-hierarchy-item-actions
      i.eye.icon(@click='show()')
      i.plus.icon(@click='add()')
      i.play.icon(@click='play()')

  loggables-hierarchy-item(v-for='child in loggable.children' :loggable='child' :key='child.id')

</template>

<script lang="coffee">
export default
  props:
    loggable:
      required: true

  methods:
    show: ->
      FedeauxOrg.system.event_bridge.$emit 'Loggables::Show', path_ids: @loggable.path_ids

    add: ->
      FedeauxOrg.system.event_bridge.$emit 'Logs::New', attributes: { loggable_id: @loggable.id }

    play: ->
      FedeauxOrg.system.event_bridge.$emit 'Logs::New', attributes: { loggable_id: @loggable.id }, autoplay: true

  computed:
    hierarchy_item_style: ->
      {
        'background-color': "##{@loggable.background_color}"
        'border': "thin solid ##{@loggable.text_color}"
        'color': "##{@loggable.text_color}"
      }

  mounted: ->
    # @show() if @loggable.id == 22

</script>
