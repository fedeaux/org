class BaseJsEnvironment
  constructor: (@js_environment_data) ->

  onInstall: ->
    # Do nothing

  onViewModelMounted: (callback) ->
    # Do nothing

  onBeforeViewModelDestroy: (callback) ->
    # Do nothing

export default BaseJsEnvironment
