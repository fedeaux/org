import BaseModel from './base_model'

class TatTarget extends BaseModel
  @collection = 'tat_targets'
  @member = 'tat_target'

  @attributes = ->
    {
      id: {}
      start: {}
      duration: {} # In seconds
      type: {}
      identifier: {}
    }

  @serializableAttributes = ->
    {
      id: {}
      start: {}
      duration: {} # In seconds
      type: {}
      identifier: {}
    }

  isVisibleAt: (time) ->
    @start <= time and time <= (@start + @duration)

export default TatTarget
