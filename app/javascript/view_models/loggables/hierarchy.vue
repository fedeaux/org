<template lang="pug">
  .loggables-hierarchy
    h1.ui.header Loggables
    loggables-hierarchy-item(v-for='loggable in loggables' :loggable='loggable' :key='loggable.id')
</template>

<script lang="coffee">

export default
  computed:
    loggables: ->
      @$store.getters['loggables/hierarchy']

  mounted: ->
    @$store.dispatch 'loggables/loadAll'

</script>
