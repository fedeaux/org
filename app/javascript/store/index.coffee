import LoggablesResource from '../resources/loggables'
import LogsResource from '../resources/logs'

Loggables =
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
  state:
    logs: []

  mutations:
    add: (store, log) ->
      store.logs.push log

  actions:
    save: ({ commit, state }, log) ->
      res = new LogsResource
      res.save log, (data) =>
        commit 'add', data.log

export default new Vuex.Store {
  modules:
    loggables: Loggables
    logs: Logs

  # getters: {
  #   logs: (query) ->

  #   loggables: ->

  # }

  # mutations: {
  #   set_log: (store, log) ->
  #   remove_log: (store, log) ->
  # }
}
