<template lang="pug">
.logs-list-item
  .logs-list-item-title
    | {{ log.loggable.name }}
    pre
      | {{ log.description }}
</template>

<script lang="coffee">
export default
  props: ['log']
</script>
