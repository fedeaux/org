<template lang="pug">
#fedeaux-org-app
  .ui.grid
    .ui.four.wide.column
      loggables-list(:loggables='loggables' v-if='loggables')

    .ui.four.wide.column
      days-show(:date='current_day' title="Today" v-if='current_day')

    .ui.four.wide.column
      days-show(:date='one_week_ago' title="One week ago" v-if='one_week_ago')

    .ui.four.wide.column
      days-show(:date='yesterday' title="Yesterday" v-if='yesterday')
</template>

<script lang="coffee">

import LoggablesResource from '../resources/loggables'

export default
  data: ->
    current_day: null
    loggables: null

  methods:
    loggablesLoaded: (data) ->
      @loggables = data.loggables

  created: ->
    @current_day = moment().startOf 'day'
    @yesterday = @current_day.clone().subtract 1, 'day'
    @one_week_ago = @current_day.clone().subtract 1, 'week'

    @loggables_resource = new LoggablesResource
    @loggables_resource.index @loggablesLoaded

</script>
