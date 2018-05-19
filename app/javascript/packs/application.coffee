import FedeauxOrg from '../fedeaux_org'
import App from '../view_models/app.vue'
import '../style/application.sass'
import 'semantic-ui-sass'

FedeauxOrg.initialize = ->
  new Vue
    el: '#fedeaux-org-app'
    render: (h) => h(App)

$ FedeauxOrg.initialize
