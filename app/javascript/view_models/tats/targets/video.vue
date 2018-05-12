<template lang="pug">
.tats-target
  .tats-target-tats-holder(v-if='visible')
    // component :is='tat_renderer_vue_component_name' tats-website-renderer
    tats-video-renderer(
      :tats='all_tats'
      :current_video_time='current_video_time'
      :there_is_some_tat_in_form='!!form_tat'
      :display='display'
    )

  template(v-if='active')
    // component :is='tat_form_vue_component_name' / tats-video-form tats-website-form
    tats-video-form(:tat='form_tat' @cancel='cancelFormTat()' @save='saveFormTat()')

    .tats-target-menu
      template(v-if='state == "idle"')
        .action-menu-item(@click='toggleDisplay()')
          template(v-if='display == "default"')
            i.fa.fa-eye

          template(v-if='display == "compact"')
            i.fa.fa-circle

          template(v-if='display == "none"')
            i.fa.fa-eye-slash

        .action-menu-item#bottom-menu-add-tat(@click="newTat()")
          i.fa.fa-plus

        .action-menu-item.tats-list-outer-wrapper(v-if="all_tats.length > 0" @click="toggleTatList($event)")
          | {{ all_tats.length }}

          .tats-list-inner-wrapper(v-if="show_tat_list")
            tats-list-index(:title="'My Tats'" :tats="my_tats" :allow_destructive_actions="true")
            tats-list-index(:title="'Other Tats'" :tats="other_tats")

      template(v-if='state == "loading"')
        .action-menu-item
          .ui.active.inline.loader

      // template v-if='state == "creating-tat"'
      //   .action-menu-item#bottom-menu-clear-form @click="clearTatForm()" 0
</template>

<script lang="coffee">
export default
  props: ['adapter', 'current_user']

  mixins: TatApp.import('vue.mixins': ['tat_manager', 'video_watcher', 'content_seeder', 'tat_display'])

  data: ->
    show_tat_list: false
    active: false
    initialized: false
    state: 'loading'

  methods:
    activate: ->
      @active = true

    deactivate: ->
      @active = false

    toggleTatList: (e) ->
      return unless $(e.target).is '.tats-list-outer-wrapper'
      @show_tat_list = !@show_tat_list
      TatApp.vue.event_bridge.$emit 'TatApp::UI::ToggleTatList', { @show_tat_list }

    initialize: ->
      return unless @adapter.install(@) # install returns false if already installed
      @clearTats()
      @findSuitableSeeders()
      @loadTats()

  computed:
    all_tats: ->
      return @tats unless @seeded_tats
      return @seeded_tats unless @tats
      @tats.concat @seeded_tats

    my_tats: ->
      return [] unless @tats and @current_user and @current_user.id
      (tat for tat in @tats when tat.user_id == @current_user.id)

    other_tats: ->
      return @all_tats unless @current_user and @current_user.id
      (tat for tat in @all_tats when tat.user_id != @current_user.id)

  watch:
    form_tat: ->
      if @form_tat # Global.Mixins.TatManager
        @ensureDefaultDisplay()

        if @form_tat.isNewRecord()
          @state = 'creating-tat'
        else
          @state = 'editing-tat'

      else
        @state = 'idle'

    active: ->
      @initialize() if @active

  mounted: ->
    @$nextTick ->
      # Dependency injection?
      TatApp.js_environment.onViewModelMounted @initialize
      @$nextTick @activate

  created: ->
    TatApp.vue.event_bridge.$on 'TatApp::Activate', @activate
    TatApp.vue.event_bridge.$on 'TatApp::Deactivate', @deactivate

    TatApp.vue.event_bridge.$on 'TatApp::Tats::Destroy', @destroyTat
    TatApp.vue.event_bridge.$on 'TatApp::Tats::Edit', @editTat
    TatApp.vue.event_bridge.$on 'TatApp::Tats::View', @viewTat

  beforeDestroy: ->
    TatApp.vue.event_bridge.$off 'TatApp::Activate', @activate
    TatApp.vue.event_bridge.$off 'TatApp::Deactivate', @deactivate

    TatApp.vue.event_bridge.$off 'TatApp::Tats::Destroy', @destroyTat
    TatApp.vue.event_bridge.$off 'TatApp::Tats::Edit', @editTat
    TatApp.vue.event_bridge.$off 'TatApp::Tats::View', @viewTat

    TatApp.js_environment.onBeforeViewModelDestroy @initialize
</script>
