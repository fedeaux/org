<template lang="pug">
.logs-list-item
  .log-timespan
    | {{ timespan }}

  pre
    | {{ log.description }}

</template>

<script lang="coffee">
export default
  props: ['log']

  computed:
    timespan: ->
      return '' unless @log and @log.start
      return @log.start.format('Do, MMM') + ' @ ' + @log.start.format('HH:mm') unless @log.finish
      @log.start.format('Do, MMM') + ' @ ' + Helpers.formatTimespanAsDuration(@log.start, @log.finish) + ' (' + @log.start.format('HH:mm') + ' -> ' + @log.finish.format('HH:mm') + ')'

</script>
