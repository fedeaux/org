window.Vue = require('vue').default
window.VueColor = require 'vue-color'
window.$ = require 'jquery'
window.jQuery = window.$
window._ = require 'underscore'

require "jquery-ui/ui/widgets/draggable"
require "jquery-ui/ui/widgets/slider"
require "./support/jquery.emojipicker.hack"
require "./support/jquery.emojipicker.emojis"

import Filters from './support/filters'

# TODO load only the needed env
js_environments = {
  chrome_extension: require('./lib/js_environments/chrome_extension').default,
  standalone: require('./lib/js_environments/standalone').default,
}

camel_case = (input) ->
  input = input.toLowerCase().replace /_(.)/gi, (match, group) ->
    group.toUpperCase()

  input.charAt(0).toUpperCase() + input.substr(1)

window.TatApp = _.extend window.TatApp,
  js_environment: new js_environments[TatApp.js_environment_data.name](TatApp.js_environment_data)

  vue:
    mixins: {}
    event_bridge: new Vue

  lib:
    adapters: {}
    analytics: null
    factories: {}
    storage: null

  api: {}

  import: (entries) ->
    ret = []

    for namespace, modules of entries
      for module in modules
        ret.push eval "TatApp.#{namespace}.#{module}"

    ret

for adapter_name in ['vevo_native', 'website', 'youtube_api', 'youtube_native']
  adapter_name_camel = camel_case adapter_name
  TatApp.lib.adapters[adapter_name_camel] = require("lib/adapters/#{adapter_name}").default

for mixin_name in ['analytics', 'tat_manager', 'video_watcher', 'content_seeder', 'tat_display', 'parent_target_component_accessor']
  TatApp.vue.mixins[mixin_name] = require("mixins/#{mixin_name}").default

# TODO: List programmatically
view_model_paths = [
  'shared/terms_and_privacy_links',
  'shared/font_size_picker',
  'tats/content/form/text',
  'tats/list/index',
  'tats/list/item',
  'tats/targets/video',
  'tats/video/content',
  'tats/video/element',
  'tats/video/form',
  'tats/video/renderer'
]

for view_model_path in view_model_paths
  component_name = view_model_path.replace(/^shared\//, '').replace(/\//g, '-').replace /_/g, '-'
  Vue.component component_name, require("view_models/#{view_model_path}").default

for name, filter of Filters
  Vue.filter name, filter

TatApp.lib.factories.adapters = require('lib/factories/adapters').default
TatApp.lib.analytics = TatApp.js_environment.instantiateAnalytics()
TatApp.lib.storage = TatApp.js_environment.instantiateStorage()

TatApp.api.AdapterFactory = TatApp.lib.factories.adapters

TatApp.js_environment.onInstall()

export default TatApp
