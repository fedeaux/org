import LoggablesResource from '../resources/loggables'
import LogsResource from '../resources/logs'

Loggables =
  namespaced: true

  state:
    loggables: []

  getters:
    all: (store) ->
      store.loggables

  mutations:
    setAll: (store, loggables) ->
      store.loggables = loggables

  actions:
    loadAll: ({ commit, state }) ->
      res = new LoggablesResource
      res.index (data) =>
        commit 'setAll', data.loggables

Logs =
  namespaced: true

  state:
    logs: []

  mutations:
    add: (store, logs) ->
      for log in _.isArray(logs) and logs or [logs]
        result = Helpers.find store.logs, log.id

        if result.index == -1
          store.logs.push log
        else
          store.logs.splice result.index, 1, log

    remove: (store, log) ->
      result = Helpers.find store.logs, log.id
      console.log 'remove', _.map(store.logs, (log) -> log.id), log, result
      store.logs.splice result.index, 1 if result.index != -1
      console.log 'remove', _.map(store.logs, (log) -> log.id), log, result

  getters:
    onDay: (store) ->
      (date) ->
        log for log in store.logs when log.isOnDay date

  actions:
    destroy: ({ commit, state }, log) ->
      res = new LogsResource
      res.destroy log, (data) =>
        commit 'remove', data.log

    save: ({ commit, state }, log) ->
      res = new LogsResource
      res.save log, (data) =>
        commit 'add', data.log

    load: ({ commit, state }, params) ->
      res = new LogsResource
      loaded = (data) ->
        commit 'add', data.logs
        params.loaded data

      # TODO. Replace with something global like "...expectMomentjsObject()"
      console.error "params.date must be a moment object" unless params.date and params.date._isAMomentObject
      res.index loaded, { date: params.date.utc().format() }

export default new Vuex.Store {
  modules:
    loggables: Loggables
    logs: Logs
}
