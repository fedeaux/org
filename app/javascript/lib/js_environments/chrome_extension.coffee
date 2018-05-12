import BaseJsEnvironment from './base_js_environment'
import Analytics from './../analytics/chrome_extension'
import Storage from './../storage/chrome_extension'

class ChromeExtension extends BaseJsEnvironment
  onInstall: ->
    # do nothing, set uninstall url has been moved to ChromeExtensionAnalytics

  onViewModelMounted: (callback) ->
    chrome.runtime.onMessage.addListener @onViewModelMountedClosure callback

  onBeforeViewModelDestroy: (callback) ->
    chrome.runtime.onMessage.removeListener callback

  onViewModelMountedClosure: (callback) ->
    (event_data) =>
      return unless event_data.event_name is 'tab-updated'
      callback()

  instantiateStorage: ->
    new Storage

  instantiateAnalytics: ->
    new Analytics

export default ChromeExtension
