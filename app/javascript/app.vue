<template lang="pug">
#tatme-app
  component(v-for="adapter in adapters"
            :is="adapter.vue_component_name"
            :adapter="adapter"
            :key="adapter.id"
            :current_user="current_user")
</template>

<script lang="coffee">

import AdapterFactory from 'lib/factories/adapters'

export default
  mixins: TatApp.import('vue.mixins': ['analytics'])

  data: ->
    adapters: []
    current_user: {}

  methods:
    addedAdapters: (data) ->
      for adapter in data.adapters
        @adapters.push adapter

    tatsLoaded: (data) ->
      return if @current_user and @current_user.id
      @current_user.id = data.user.id
      @saveCurrentUser()
      TatApp.lib.analytics.setUserId @current_user.id

    fetchCurrentUser: ->
      TatApp.lib.storage.get 'current_user', @currentUserFetched

    currentUserFetched: (data) ->
      @current_user = data.current_user or {}
      return unless @current_user.id
      TatApp.lib.analytics.setUserId @current_user.id

    saveCurrentUser: ->
      TatApp.lib.storage.set current_user: @current_user

  mounted: ->
    TatApp.vue.event_bridge.$on 'TatApp::Adapters::Added', @addedAdapters
    TatApp.vue.event_bridge.$on 'TatApp::Tats::Loaded', @tatsLoaded
    AdapterFactory.findAllTargets()
    @fetchCurrentUser()

  beforeDestroy: ->
    TatApp.vue.event_bridge.$off 'TatApp::Adapters::Added', @addedAdapters
    TatApp.vue.event_bridge.$off 'TatApp::Tats::Loaded', @tatsLoaded

</script>
