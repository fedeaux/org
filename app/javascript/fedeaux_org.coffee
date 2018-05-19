window.Vue = require('vue').default
window.VueColor = require 'vue-color'
window.Vuex = require('vuex').default


window.$ = require 'jquery'
window.jQuery = window.$
window._ = require 'underscore'
window.moment = require 'moment'

import Filters from './support/filters'
import SuiVue from 'semantic-ui-vue'

Vue.use SuiVue
Vue.use Vuex

camel_case = (input) ->
  input = input.toLowerCase().replace /_(.)/gi, (match, group) ->
    group.toUpperCase()

  input.charAt(0).toUpperCase() + input.substr(1)

window.FedeauxOrg = _.extend window.FedeauxOrg,
  system:
    event_bridge: new Vue

# TODO: List programmatically
view_model_paths = [
  'shared/menu'
  'days/show'
  'loggables/hierarchy'
  'loggables/hierarchy/item'
  'logs/form'
]

for view_model_path in view_model_paths
  component_name = view_model_path.replace(/\//g, '-').replace /_/g, '-'
  console.log "view_models/#{view_model_path}"
  Vue.component component_name, require("view_models/#{view_model_path}").default

for name, filter of Filters
  Vue.filter name, filter

export default FedeauxOrg
