import FedeauxOrg from '../fedeaux_org'
import App from '../view_models/app.vue'
import '../style/application.sass'
import 'semantic-ui-sass'

window.Helpers =
  find: (collection, id) ->
    for index, item of collection
      return { index, item } if item.id == id

    {
      index: -1
      item: null
    }

FedeauxOrg.initialize = ->
  new Vue
    el: '#fedeaux-org-app'
    render: (h) => h(App)

$ FedeauxOrg.initialize
