import BaseModel from './base_model'

class Loggable extends BaseModel
  @collection = 'loggables'
  @member = 'loggable'

  @attributes = ->
    {
      id: {}
      name: {}
      text_color: {}
      background_color: {}
      children: { type: Loggable }
    }

export default Loggable
