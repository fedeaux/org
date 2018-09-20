<template lang="pug">
.dashboard-item-header
  h1.ui.header.dashboard-item-header-title
    | {{ title }}
    .sub.header(v-if='sub_title')
      | {{ sub_title }}

    .dashboard-item-header-actions
      i.action.delete.icon(@click='forceHideParent()')

</template>

<script lang="coffee">
export default
  props: ['title', 'sub_title']

  methods:
    forceHideParent: ->
      @$parent.forceHide()

</script>
