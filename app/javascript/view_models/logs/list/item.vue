<template lang="pug">
.logs-list-item(@click='showMenu()')
  logs-item-menu(v-if='show_menu' :log='log' @hide='hideMenu()')

  .log-timespan
    | {{ timespan }}

  pre.logs-item-description
    | {{ log.description }}

</template>

<script lang="coffee">

import MenuMixin from '../../../mixins/menu'

export default
  mixins: [MenuMixin]
  props: ['log']

  computed:
    timespan: ->
      return '' unless @log and @log.start
      return @log.start.format('Do, MMM') + ' @ ' + @log.start.format('HH:mm') unless @log.finish
      @log.start.format('Do, MMM') + ' @ ' + Helpers.formatTimespanAsDuration(@log.start, @log.finish) + ' (' + @log.start.format('HH:mm') + ' -> ' + @log.finish.format('HH:mm') + ')'

</script>
