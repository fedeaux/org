import BaseModel from './base_model'

class TatContent extends BaseModel
  @collection = 'tat_contents'
  @member = 'tat_content'

  @attributes = ->
    {
      id: {}
      properties: {}
      content: {}
      content_type: {}
    }

  @seralizableAttributes = ->
    {
      id: {}
      properties: {}
      content: {}
      content_type: {}
    }

  normalizeSpacialProperties: (denormalized_spacial_properties, container_box_model) ->
    top = (denormalized_spacial_properties.top - container_box_model.top) / container_box_model.height
    left = (denormalized_spacial_properties.left - container_box_model.left) / container_box_model.width
    font_size = denormalized_spacial_properties['font-size'] / container_box_model.height

    @properties.normalized = @normalizedProperties()

    @properties.normalized.top = top
    @properties.normalized.left = left
    @properties.normalized['font-size'] = font_size

  denormalizedOuterContainerStyle: (container_box_model) ->
    @denormalizedStyle container_box_model, only: ['top', 'left', 'font-size']

  denormalizedInnerContainerStyle: (container_box_model) ->
    @denormalizedStyle container_box_model, except: ['top', 'left', 'font-size']

  denormalizedStyle: (container_box_model, options = {}) ->
    options.only ||= []
    options.except ||= []

    # merges non normalizable attributes (like color, background-color and font-family)
    # with denormalized spacial attributes (see denormalizedSpacialAttributes below)

    style = _.extend @nonNormalizableProperties(), @denormalizedSpacialProperties(container_box_model)

    transform_value = @transformCssPropertyValue()
    style.transform = transform_value if transform_value

    _.object (
      [key, value] for key, value of style when (options.only.length == 0 or key in options.only) and key not in options.except
    )

  denormalizedSpacialProperties: (container_box_model) ->
    # spacial properties (like height, width, font-size, left, top) are
    # stored as percentages of the container's (for now always a video) spacial properties (normalized)
    # (in properties.normalized_properties) see TatApp.Factories.TextTat

    normalized = @normalizedProperties()
    denormalized = {}

    # mandatory properties
    for height_dependent_attribute in ['top', 'font-size']
      denormalized[height_dependent_attribute] = parseFloat(normalized[height_dependent_attribute]) * container_box_model.height

    for width_dependent_attribute in ['left']
      denormalized[width_dependent_attribute] = parseFloat(normalized[width_dependent_attribute]) * container_box_model.width

    # fixes
    denormalized.top = (denormalized.top + container_box_model.top)+'px'
    denormalized.left = (denormalized.left + container_box_model.left)+'px'
    denormalized['font-size'] = denormalized['font-size']+'px'

    denormalized

  nonNormalizableProperties: ->
    @properties and @properties.css or {}

  normalizedProperties: ->
    @properties and @properties.normalized or {}

  transformationProperties: ->
    @properties and @properties.transformations or {}

  setProperty: (name, value) ->
    @properties ?= {}
    @properties[name] = value

  transformCssPropertyValue: ->
    transformations = []

    for name, value of @transformationProperties()
      transformations.push "#{name}(#{value})"

    return null if transformations.length == 0
    "#{transformations.join(' ')}"

export default TatContent
