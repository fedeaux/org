class BaseResource
  index: (success, params = {}) ->
    $.ajax
      url: @collectionUrl()
      type: 'get'
      data: params
      success: @collectionClosure(success)

  get: (id, success) ->
    model = @model()
    $.get @memberUrl(new model(id: id)), @memberClosure success

  save: (member, success) ->
    if member.isNewRecord()
      @create member, success
    else
      @update member, success

  create: (member, success) ->
    data = {}
    data[@member()] = member.serializeForSave()

    $.ajax
      type: 'POST'
      url: @collectionUrl()
      data: data
      success: @memberClosure success, is_create: true

  update: (member, success) ->
    data = {}
    data[@member()] = member.serializeForSave()

    $.ajax
      type: 'PATCH',
      url: @memberUrl member
      data: data
      success: @memberClosure success, is_update: true

  destroy: (member, success) ->
    $.ajax
      type: 'DELETE',
      url: @memberUrl member
      success: @destroyClosure member, success

  # Callbacks
  memberClosure: (success, _data = {}) =>
    (data) =>
      data = _.extend _data, data
      model = @model()
      data[@member()] = new model data[@member()]
      success data if success

  collectionClosure: (success) =>
    (data) =>
      model = @model()
      items = []

      for item_attr in data[@collection()]
        items.push new model item_attr

      data[@collection()] = items
      success data if success

  destroyClosure: (member, success) =>
    =>
      response = {}
      response[@member()] = member
      success response if success

  # Helpers
  collectionUrl: ->
    @path2url "/#{@collection()}.json"

  memberUrl: (member, path = '') ->
    @path2url "#{member.path()}#{path}.json"

  collection: ->
    @model().collection

  member: ->
    @model().member

  model: ->
    @constructor.model()

  path2url: (path) ->
    "#{FedeauxOrg.config.api_url}#{path}"

export default BaseResource
