import BaseSeeder from './base_seeder'

class DomBasedYoutubeComments extends BaseSeeder
  @isSuitableForCurrentPage: ->
    # This seeder is a fallback for TatApp.Seeders.YoutubeComments
    # used when youtube's api gives an error
    false

  initialize: ->
    @instantiateObserver()

  instantiateObserver: ->
    @observer_timeout = null
    MutationObserver = window.MutationObserver or window.WebKitMutationObserver
    @observer = new MutationObserver @onMutation
    @installObserver()

  installObserver: =>
    try
      @observer.observe $('ytd-comments')[0],
        subtree: true
        attributes: true

    catch
      setTimeout @installObserver, 1000

  onMutation: (mutations, observer) =>
    clearTimeout @observer_timeout if @observer_timeout
    @observer_timeout = setTimeout @findComments, 1000

  findCommentTextFromLink: (link) ->
    link.parent().text()

  findComments: =>
    for _link in $('ytd-comments yt-formatted-string.ytd-comment-renderer a')
      link = $ _link
      url = new URL link.attr('href'), window.location.origin

      t = url.searchParams.get 't'
      continue unless t

      text = @findCommentTextFromLink link
      continue unless text

      @addCommentUnlessExists text, t

  remove: ->
    @observer.disconnect()

export default DomBasedYoutubeComments
