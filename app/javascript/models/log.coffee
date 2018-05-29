import BaseModel from './base_model'
import Loggable from './loggable'

class Log extends BaseModel
  @collection = 'logs'
  @member = 'log'

  @attributes = ->
    {
      id: {}
      description: {}
      finish: { type: moment }
      loggable: { type: Loggable }
      loggable_id: {}
      start: { type: moment }
    }

  isOnDay: (date) ->
    true

export default Log
