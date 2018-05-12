import Html5Video from './html5_video'

class VevoVideo extends Html5Video
  videoElSelector: ->
    @video_el = $ '#html5-player'

export default VevoVideo
