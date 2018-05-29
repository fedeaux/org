export default
  methods:
    destroyLog: (data) ->
      log = @removeLog data.log
      return unless log

      @logs_resource.destroy log
      FedeauxOrg.vue.event_bridge.$emit 'FedeauxOrg::Logs::Destroyed'

    setFormLog: (log) ->
      @previous_form_log = log.clone() if log.isPersisted()
      @form_log = log
      @form_log.form_log = true

    clearFormLog: ->
      @form_log = null
      @previous_form_log = null

      # Filter non persisted form_logs
      @logs = @logs.filter (log) ->
        !log.form_log

    cancelFormLog: ->
      event_name = @form_log.isNewRecord() and 'FedeauxOrg::Logs::CancelCreate' or 'FedeauxOrg::Logs::CancelEdit'
      FedeauxOrg.vue.event_bridge.$emit event_name, { log: @form_log }

      if @form_log.isPersisted()
        # Keep logs being edited
        if @previous_form_log
          @removeLog @form_log
          @addLog @previous_form_log

        else
          # clearFormLog() will remove this log
          @form_log.form_log = false

      @clearFormLog()
      @video_watcher.play()

    saveFormLog: ->
      @logs_resource.save @form_log, @saveFormLogSuccess, @saveFormLogFailure

    saveFormLogSuccess: (data) ->
      @video_watcher.play()
      @clearFormLog()
      @logs.push data.log

      event_name = data.is_create and 'FedeauxOrg::Logs::Created' or 'FedeauxOrg::Logs::Updated'
      FedeauxOrg.vue.event_bridge.$emit event_name, { log: data.log }

    saveFormLogFailure: (response) ->
      @sloge = 'idle' # smells like dependency injection
      console.log 'failure', response
