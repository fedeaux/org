<template lang="pug">
.logs-list
  logs-list-item(v-for='log in logs' :key='log.id' :log='log' :style='logStyle(log)')

</template>

<script lang="coffee">
export default
  props: ['logs']

  methods:
    logStyle: (log) ->
      {
        'background-color': "##{log.loggable.background_color}"
        'padding-left': '4px'
        'border-radius': '4px'
        color: "##{log.loggable.text_color}"
        height: 'auto'
        border: "1px solid ##{log.loggable.text_color}"
      }
</script>
