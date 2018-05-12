import BaseSeeder from './base_seeder'
import DomBasedYoutubeComments from './dom_based_youtube_comments'

class YoutubeComments extends BaseSeeder
  @isSuitableForCurrentPage: ->
    !!window.location.hostname.match /youtube.com/

  initialize: ->
    $.ajax
      url: @youtubeCommentThreadsUrl()
      success: @findComments
      error: @fallbackToDomBasedSeeder

  remove: ->
    @removed = true
    @dom_based_seeder.remove() if @dom_based_seeder

  youtubeCommentThreadsUrl: ->
    "https://www.googleapis.com/youtube/v3/commentThreads?videoId=#{@adapter.targetIdentifier()}&part=snippet&key=#{TatApp.config.youtube_api_key}"

  findComments: (data) =>
    return if @removed
    for item in data.items
      text = item.snippet.topLevelComment.snippet.textOriginal
      t = @getTimeParameter text
      continue unless t
      @addCommentUnlessExists text, t

  getTimeParameter: (comment) ->
    regex = /(^|\s)(\d?\d\:\d\d)($|\s)/
    result = regex.exec comment
    return false unless result
    @timeText2timeSeconds result[2]

  timeText2timeSeconds: (text) ->
    parts = text.split ':'
    parseInt(parts[0]) * 60 + parseInt(parts[1])

  fallbackToDomBasedSeeder: =>
    return if @dom_based_seeder
    @dom_based_seeder = new DomBasedYoutubeComments @onNewContent, @adapter

export default YoutubeComments
