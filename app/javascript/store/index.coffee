import LoggablesResource from '../resources/loggables'

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

export default new Vuex.Store {
  modules:
    loggables: Loggables

  # getters: {
  #   logs: (query) ->

  #   loggables: ->

  # }

  # mutations: {
  #   set_log: (store, log) ->
  #   remove_log: (store, log) ->
  # }
}
