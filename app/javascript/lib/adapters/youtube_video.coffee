import Video from './video'
import YoutubeComments from '../seeders/youtube_comments'

class YoutubeVideo extends Video
  targetType: ->
    'TatTargetYoutubeVideo'

  instantiateContentSeeders: (onNewContent) ->
    [new YoutubeComments(onNewContent, @)]

export default YoutubeVideo
