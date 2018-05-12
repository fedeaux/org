import BaseModel from './base_model'
import TatTarget from './tat_target'
import TatContent from './tat_content'

class Tat extends BaseModel
  @collection = 'tats'
  @member = 'tat'

  @attributes = ->
    {
      id: {}
      target: { type: TatTarget } # has_one
      contents: { type: TatContent } # has_many
      form_tat: { default: false } # see mixins/tat_manager
      user_id: {} # see mixins/tat_manager
      # TODO think better about this form_tat, maybe adding a data form_tat to TatManager
    }

  @serializableAttributes = ->
    {
      id: {}
      user_id: {}
      target: { type: TatTarget } # has_one
      contents: { type: TatContent } # has_many
    }

  isVisibleAt: (time) ->
    @form_tat or (@target and @target.isVisibleAt time)

  serializeForSave: ->
    # TODO wtf
    {
      id: @id
      user_id: @user_id
      target_attributes: @serializeAttribute @target, 'target'
      contents_attributes: @serializeAttribute @contents, 'contents'
    }

  boxModel: (container_box_model) ->
    # broken
    #
    #
    # return null if @contents.length == 0 # TODO default value

    # box_model =
    #   left: false
    #   top: false

    # bottom = false
    # right = false

    # for content in @contents
    #   denormalized_spacial_properties = content.denormalizedSpacialProperties container_box_model

    #   # min top and left
    #   if box_model.top is false or box_model.top > denormalized_spacial_properties.top
    #     box_model.top = denormalized_spacial_properties.top

    #   if box_model.left is false or box_model.left > denormalized_spacial_properties.left
    #     box_model.left = denormalized_spacial_properties.left

    #   # max bottom and right
    #   if bottom is false or bottom < denormalized_spacial_properties.bottom
    #     bottom = denormalized_spacial_properties.bottom

    #   if right is false or right < denormalized_spacial_properties.right
    #     right = denormalized_spacial_properties.right

    # box_model.height =

    # box_model

export default Tat
