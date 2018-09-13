import LoggablesResource from '../resources/loggables'
import LogsResource from '../resources/logs'

Loggables =
  namespaced: true

  state:
    loggables: []

  getters:
    all: (store) ->
      store.loggables

    byPathIds: (store) ->
      byPathIdsRec = (loggables, path_ids) ->
        id = path_ids.shift()
        result = Helpers.find loggables, id
        return null if result.item is null
        return result.item if path_ids.length == 0
        byPathIdsRec result.item.children, path_ids

      (path_ids) ->
        byPathIdsRec store.loggables, path_ids

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

      FedeauxOrg.system.event_bridge.$emit 'Logs::Changed'

    remove: (store, log) ->
      result = Helpers.find store.logs, log.id
      store.logs.splice result.index, 1 if result.index != -1

      FedeauxOrg.system.event_bridge.$emit 'Logs::Changed'

  getters:
    onDay: (store) ->
      (date) ->
        log for log in store.logs when log.isOnDay date

    byLoggableId: (store) ->
      (loggable_id) ->
        log for log in store.logs when log.loggable_id == loggable_id

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

      if params.date and params.date._isAMomentObject
        res.index loaded, { date: params.date.utc().format() }
      else if params.loggable_id
        res.index loaded, { loggable_id: params.loggable_id }
      else
        console.error "params.date or params.loggable_id must be set"

export default new Vuex.Store {
  modules:
    loggables: Loggables
    logs: Logs
}
