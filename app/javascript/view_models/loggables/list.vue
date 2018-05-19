<template lang="pug">
  .loggables-list
    h1.ui.header Loggables

    loggables-list-item(v-for='loggable in loggables' :loggable='loggable' :key='loggable.id')
</template>

<script lang="coffee">
export default
  props:
    loggables:
      required: true
</script>
