<template lang="pug">
.logs-timeline-item(@click='showMenu()')
  logs-timeline-item-menu(v-if='show_menu' :log='log' @hide='hideMenu()')

  .logs-timeline-item-title
    | {{ log.loggable.name }}

</template>

<script lang="coffee">
export default
  props: ['log']

  data: ->
    show_menu: false

  methods:
    showMenu: ->
      @show_menu = true

    hideMenu: ->
      @show_menu = false

</script>
