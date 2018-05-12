import BaseJsEnvironment from './base_js_environment'
import Analytics from './../analytics/standalone'
import Storage from './../storage/local'

class Standalone extends BaseJsEnvironment
  instantiateStorage: ->
    new Storage

  instantiateAnalytics: ->
    new Analytics

export default Standalone
