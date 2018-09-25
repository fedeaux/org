<template lang="pug">
  pre.logs-item-description
    | {{ log.description }}
</template>

<script lang="coffee">
  export default
    props: ['log']
</script>
