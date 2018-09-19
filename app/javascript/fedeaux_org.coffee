window.Vue = require('vue').default
window.VueColor = require 'vue-color'
window.Vuex = require('vuex').default

window.$ = require 'jquery'
window.jQuery = window.$
window._ = require 'underscore'
window.voca = require 'voca'
window.moment = require 'moment'

import Helpers from 'support/helpers'
window.Helpers = Helpers

import Filters from './support/filters'
import SuiVue from 'semantic-ui-vue'
import Datepicker from 'vuejs-datepicker'

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
  'days/show'
  'loggables/select'
  'loggables/show'
  'loggables/hierarchy'
  'loggables/hierarchy/item'
  'logs/form'
  'logs/list'
  'logs/list/item'
  'logs/timeline'
  'logs/timeline/item'
  'logs/timeline/ruler'
  'logs/timeline/item/menu'

  'inputs/datetime_picker'
  'widgets/chronometer/field'
]

replaces = [
    [/^inputs\//, '']
    [/^widgets\//, '']
    [/\//g, '-']
    [/_/g, '-']
  ]

for view_model_path in view_model_paths
  component_name = view_model_path
  for replace in replaces
    component_name = component_name.replace replace[0], replace[1]

  Vue.component component_name, require("view_models/#{view_model_path}").default
  Vue.component 'datepicker', Datepicker

for name, filter of Filters
  Vue.filter name, filter

export default FedeauxOrg
