<template lang="pug">
  .tats-list(v-if="tats.length > 0")
    .tats-list-title
      | {{ title }}

    tats-list-item(v-for="tat in tats" :key="tat.id" :tat="tat" :allow_destructive_actions="allow_destructive_actions")
</template>

<script lang="coffee">
export default
  props:
    tats:
      required: true

    title:
      required: true

    allow_destructive_actions:
      default: false
</script>
