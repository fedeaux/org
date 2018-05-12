class RotationPicker
  constructor: (@element, @handle_selector, @onFinishRotation) ->
    @dragging = false
    @initial_y = null
    @initial_angle = null
    @rotate_value = null

    $(document).on 'mousedown', @handle_selector, @startDrag
    $(document).on 'mousemove', @moveDrag
    $(document).on 'mouseup', @finishDrag

  startDrag: (e) =>
    # TODO: Use @initial_angle to fix glitch on rotation elements with an initial rotation
    @initial_angle = @getElementAngle()
    @center = @findElementCenter()
    @dragging = true
    e.preventDefault()

  getElementAngle: ->
    matrix = @element.css('-webkit-transform') or @element.css('-moz-transform') or @element.css('-ms-transform') or @element.css('-o-transform') or @element.css('transform')

    # Definition of duct tape oriented programming
    try
      values = (parseFloat value for value in matrix.split('(')[1].split(')')[0].split(','))
      angle = Math.atan2(values[1], values[0])

    catch
      angle = 0

    if angle < 0 then angle + 360 else angle

  findElementCenter: ->
    height = @element.height()
    width = @element.width()
    offset = @element.offset()

    {
      x: offset.left + width / 2
      y: offset.top + height / 2
    }

  angleBetweenPoints: (center, point) ->
    base = point.x - center.x
    height = point.y - center.y

    angle = Math.atan(height / base)
    return angle if base > 0
    Math.PI + angle

  moveDrag: (e) =>
    return unless @dragging
    current_point =
      x: e.clientX
      y: e.clientY

    angle = @angleBetweenPoints @center, current_point
    @rotate_value = "#{angle}rad"

    transform = "rotate(#{@rotate_value})"
    @element.css transform: transform

    e.preventDefault()

  finishDrag: (e) =>
    return unless @dragging
    @onFinishRotation(@rotate_value) if @onFinishRotation
    @dragging = false
    e.preventDefault()

export default RotationPicker
