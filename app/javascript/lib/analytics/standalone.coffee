class StandaloneAnalytics
  constructor: ->
    @installGoogleAnalytics()

  event: (name, data) ->
    ga 'send', 'event', name, JSON.stringify data

  setUserId: (user_id) ->
    return unless user_id
    ga 'set', 'userId', user_id

  installGoogleAnalytics: ->
    ((i, s, o, g, r, a, m) ->
      i['GoogleAnalyticsObject'] = r
      i[r] = i[r] or ->
        (i[r].q = i[r].q or []).push arguments
        return

      i[r].l = 1 * new Date
      a = s.createElement(o)
      m = s.getElementsByTagName(o)[0]
      a.async = 1
      a.src = g
      m.parentNode.insertBefore a, m
      return
    ) window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga'
    ga 'create', TatApp.config.ga_tracker_code, 'auto'
    ga 'send', 'pageview'

export default StandaloneAnalytics
