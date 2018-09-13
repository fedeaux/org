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
    (@finish and date_signature == @finish.format('DDMMYYYY')) or date_signature == @start.format('DDMMYYYY')
    # TODO: Corner case: A log that goes through multiple days

  startUtc: ->
    @timeAsUtc @start

  finishUtc: ->
    @timeAsUtc @finish

  timeAsUtc: (time) ->
    return null unless time

    as_utc = time.clone().utc()
    as_utc.add 'minutes', time.utcOffset()

export default Log
