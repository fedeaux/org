class BaseAdapter
  # Abstract Class, use one of its descendents instead
  @isApplicable: ->
    false

  constructor: ->
    # TODO better random id generator
    @id = Math.floor(Math.random() * Math.floor(9999999))

  install: (view_model) ->
    # returns false if already installed
    return false if @isInstalled()

    @video_watcher = @instantiateVideoWatcher view_model.videoWatcherCallbacks()
    view_model.video_watcher = @video_watcher

    @installed_target =
      type: @targetType()
      identifier: @targetIdentifier()

  isInstalled: ->
    return false unless @video_watcher and @installed_target
    return true if @installed_target.type == @targetType() and @installed_target.identifier == @targetIdentifier()
    false

  instantiateContentSeeders: ->
    []

export default BaseAdapter
