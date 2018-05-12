import TatsResource from '../resources/tats'
import TextTatFactory from '../lib/factories/text_tat'

export default
  data: ->
    form_tat: null
    previous_form_tat: null
    tats: []

  methods:
    clearTats: ->
      @tats = []

    loadTats: ->
      data =
        target: @adapter.targetAttributes()

      data.user_id = @current_user.id if @current_user and @current_user.id
      @tats_resource.index @tatsLoaded, data

    tatsLoaded: (data) ->
      @state = 'idle' # smells like dependency injection
      @tats = data.tats
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::Loaded', data

      # @newTat()

    newTat: ->
      @video_watcher.onBeforeNewTat()

      current_time = @video_watcher.currentTime()

      @form_tat = TextTatFactory.buildRandomTextTat ['TatChup is awesome :)'], @adapter.targetAttributes(current_time)
      @form_tat.user_id = @current_user.id # TODO put in factory
      @addTat @form_tat

      TatApp.vue.event_bridge.$emit 'TatApp::Tats::New'

    addTat: (tat) ->
      @tats.unshift tat

    findIndex: (tat) ->
      for index, _tat of @tats
        return index if _tat.id == tat.id

      -1

    destroyTat: (data) ->
      tat = @removeTat data.tat
      return unless tat

      @tats_resource.destroy tat
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::Destroyed'

    removeTat: (tat) ->
      index = @findIndex tat
      return false if index == -1

      tat = @tats[index]
      @tats.splice index, 1
      tat

    editTat: (data) ->
      index = @findIndex data.tat
      return if index == -1

      @video_watcher.onBeforeNewTat()
      tat = @tats[index]
      @viewTat { tat }
      @setFormTat tat

    setFormTat: (tat) ->
      @previous_form_tat = tat.clone() if tat.isPersisted()
      @form_tat = tat
      @form_tat.form_tat = true

    clearFormTat: ->
      @form_tat = null
      @previous_form_tat = null

      # Filter non persisted form_tats
      @tats = @tats.filter (tat) ->
        !tat.form_tat

    cancelFormTat: ->
      event_name = @form_tat.isNewRecord() and 'TatApp::Tats::CancelCreate' or 'TatApp::Tats::CancelEdit'
      TatApp.vue.event_bridge.$emit event_name, { tat: @form_tat }

      if @form_tat.isPersisted()
        # Keep tats being edited
        if @previous_form_tat
          @removeTat @form_tat
          @addTat @previous_form_tat

        else
          # clearFormTat() will remove this tat
          @form_tat.form_tat = false

      @clearFormTat()
      @video_watcher.play()

    saveFormTat: ->
      @state = 'loading' # smells like dependency injection
      @tats_resource.save @form_tat, @saveFormTatSuccess, @saveFormTatFailure

    saveFormTatSuccess: (data) ->
      @video_watcher.play()
      @state = 'idle' # smells like dependency injection
      @clearFormTat()
      @tats.push data.tat

      event_name = data.is_create and 'TatApp::Tats::Created' or 'TatApp::Tats::Updated'
      TatApp.vue.event_bridge.$emit event_name, { tat: data.tat }

    saveFormTatFailure: (response) ->
      @state = 'idle' # smells like dependency injection
      console.log 'failure', response

  mounted: ->
    @tats_resource = new TatsResource
