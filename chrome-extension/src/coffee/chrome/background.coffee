chrome.runtime.onInstalled.addListener ->
  chrome.declarativeContent.onPageChanged.removeRules undefined, ->
    chrome.declarativeContent.onPageChanged.addRules [ {
      conditions: []
      actions: [ new (chrome.declarativeContent.ShowPageAction) ]
    } ]

chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
  if changeInfo and changeInfo.status == 'complete'
    chrome.tabs.sendMessage tabId, { event_name: 'tab-updated' }

chrome.runtime.onMessage.addListener (data, event, sendResponse) ->
  return unless Actions[data.action]
  Actions[data.action](data.data, event)

Actions =
  ga_event: (data, event) ->
    window.ga 'send', 'event', data.name, JSON.stringify(data.data)

  ga_set_user_id: (data, event) ->
    return unless data.user_id
    window.ga 'set', 'userId', data.user_id

  set_uninstall_url: (data) ->
    chrome.runtime.setUninstallURL data.url

# Google Analytics
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

ga 'create', 'UA-118712071-1', 'auto' #TODO: Put this somewhere else
ga 'set', 'checkProtocolTask', ->
ga 'require', 'displayfeatures'
ga 'send', 'pageview', '/_generated_background_page.html'
