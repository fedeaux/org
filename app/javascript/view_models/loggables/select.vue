<template lang="pug">
  sui-dropdown(placeholder="Loggable"
               :search="true"
               :selection="true"
               :options="options()"
               v-model="inner_selected")
</template>

<script lang="coffee">

export default
  model:
    prop: 'selected'
    event: 'change'

  props: ['selected']

  data: ->
    inner_selected: null

  methods:
    options: ->
      options = []
      for loggable in @loggables
        @addLoggableAsOption options, loggable

      options

    addLoggableAsOption: (options, loggable, path = []) ->
      _path = path.slice 0
      _path.push loggable.name

      options.push { key: loggable.id, value: loggable.id, text: _path.join('::') }
      return unless loggable.children

      for child in loggable.children
        @addLoggableAsOption options, child, _path

  watch:
    selected: ->
      @inner_selected = @selected

    inner_selected: ->
      return if @inner_selected == @selected
      @$emit 'change', @inner_selected

  computed:
    loggables: ->
      @$store.getters['loggables/all']

  created: ->
    @inner_selected = @selected

</script>
