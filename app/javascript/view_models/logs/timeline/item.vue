<template lang="pug">
.logs-timeline-item(@click='showMenu()')
  logs-item-menu(v-if='show_menu' :log='log' @hide='hideMenu()')

  .logs-timeline-item-title
    | {{ log.loggable.name }}

  pre.logs-item-description
    | {{ log.description }}

</template>

<script lang="coffee">

import MenuMixin from '../../../mixins/menu'

export default
  mixins: [MenuMixin]
  props: ['log']
 </script>
