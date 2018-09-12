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
    date_signature = date.format 'DDMMYYYY'
    date_signature == @finish.format('DDMMYYYY') or date_signature == @start.format('DDMMYYYY')
    # TODO: Corner case: A log that goes through multiple days

export default Log
