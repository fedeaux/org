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
    add: (store, log) ->
      store.logs.push log

  getters:
    onDay: (date) ->
      log for log in @logs when log.isOnDay date

  actions:
    save: ({ commit, state }, log) ->
      res = new LogsResource
      res.save log, (data) =>
        commit 'add', data.log

    load: ({ commit, state }, params) ->
      res = new LogsResource
      success = (data) =>
        console.log data

      res.index success, params

export default new Vuex.Store {
  modules:
    loggables: Loggables
    logs: Logs
}
