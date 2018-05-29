<template lang="pug">
.logs-list-item
  .logs-list-item-title
    | {{ log.loggable.name }}
</template>

<script lang="coffee">
export default
  props: ['log']
</script>
