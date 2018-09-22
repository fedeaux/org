<template lang="pug">
.days-navigator.ui.tiny.fluid.basic.buttons
  .ui.button(@click='openDay(yesterday)')
    | {{ yesterday.format('ddd, MMM Do') }}
  .ui.button(@click='openDay(tomorrow)')
    | {{ tomorrow.format('ddd, MMM Do') }}

</template>

<script lang="coffee">

export default
  props:
    date:
      required: true

  computed:
    yesterday: ->
      return null unless @date
      @date.clone().subtract 1, 'day'

    tomorrow: ->
      return null unless @date
      @date.clone().add 1, 'day'

  methods:
    openDay: (date) ->
      FedeauxOrg.system.event_bridge.$emit 'Days::Show', { date }

</script>
