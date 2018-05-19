<template lang="pug">
  .days-show
    h1.ui.header
      | {{ title }}

      .ui.sub.header
        | {{ date | weekday_month_monthday }}

    .ui.divider

    logs-form

</template>

<script lang="coffee">
export default
  props:
    date:
      required: true

    title:
      default: 'Day'

</script>
