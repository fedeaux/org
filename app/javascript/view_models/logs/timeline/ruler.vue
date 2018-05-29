<template lang="pug">
.logs-timeline-ruler
  .logs-timeline-ruler-element(v-for='step in steps' :class='rulerElementClass(step)' :style='rulerElementStyle(step)')
    | {{ rulerElementText(step) }}

</template>

<script lang="coffee">
export default
  props:
    px_per_block:
      default: 15

    minutes_per_block:
      default: 30

  data: ->
    steps: []

  methods:
    rulerElementClass: (step) ->
      ''

    rulerElementStyle: (step) ->
      {
        height: "#{@px_per_block}px"
      }

    rulerElementText: (step) ->
      minutes = step * @minutes_per_block
      hours = parseInt minutes / 60
      minutes -= hours * 60

      hours = "0#{hours}" if hours < 10
      minutes = "0#{minutes}" if minutes < 10

      "#{hours}:#{minutes}"

  created: ->
    blocks_in_a_day = 60*24/@minutes_per_block
    @steps = [0..blocks_in_a_day]
</script>
