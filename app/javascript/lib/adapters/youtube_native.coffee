import YoutubeVideo from './youtube_video'
import Html5VideoWatcher from '../watchers/html5_video.coffee'

class YoutubeNative extends YoutubeVideo
  @isApplicable: ->
    new URL(window.location).hostname == 'www.youtube.com'

  instantiateVideoWatcher: (callbacks) ->
    new Html5VideoWatcher callbacks

  targetIdentifier: ->
    new URL(window.location).searchParams.get "v"

export default YoutubeNative
