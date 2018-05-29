<template lang="pug">
.logs-timeline-item
  .logs-timeline-item-title
    | {{ log.loggable.name }}
</template>

<script lang="coffee">
export default
  props: ['log']
</script>
