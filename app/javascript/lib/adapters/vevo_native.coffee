import BaseAdapter from './base_adapter'
import VevoVideoWatcher from '../watchers/vevo_video.coffee'

class VevoNative extends BaseAdapter
  @isApplicable: ->
    new URL(window.location).hostname == 'www.vevo.com'

  targetType: ->
    'TatTargetVevoVideo'

  instantiateVideoWatcher: (callbacks) ->
    new VevoVideoWatcher callbacks

  targetIdentifier: ->
    parts = (new URL window.location).pathname.split '/'
    parts[parts.length - 1]

export default VevoNative
