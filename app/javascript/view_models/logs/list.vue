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
        'color': "##{log.loggable.text_color}"
        'height': @timespanToPx(log)
        'border-left': "4px solid ##{log.loggable.text_color}"
      }

    timespanToPx: (log) ->
      '100px'
</script>
