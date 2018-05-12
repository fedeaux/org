class ChromeExtensionAnalytics
  constructor: ->
    # More analytics can be added here
    @installGoogleAnalytics()

  event: (name, data) ->
    # Sends a message to background.js, where ga is installed
    chrome.runtime.sendMessage action: 'ga_event', data: { name, data }

  setUserId: (user_id) ->
    return unless user_id
    chrome.runtime.sendMessage action: 'ga_set_user_id', data: { user_id }

    # Setting uninstall url
    url = "#{TatApp.config.api_url}/uninstall?user_id=#{user_id}"
    chrome.runtime.sendMessage action: 'set_uninstall_url', data: { url }

  installGoogleAnalytics: ->
    # Do nothing as for chrome extensions analytics is installed in background.js

export default ChromeExtensionAnalytics
