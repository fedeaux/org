class BaseVideo
  onBeforeNewTat: ->
    @pause()
    $window = $ window
    target = @targetEl()
    target_top = target.offset().top
    current_scroll = $window.scrollTop()
    $window.scrollTop Math.max(target_top - 60, 0) # Duct tape to scroll with some margin

export default BaseVideo
