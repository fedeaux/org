import App from '../view_models/app.vue'
import FedeauxOrg from '../fedeaux_org'

FedeauxOrg.initialize = ->
  new Vue el: '#tatme-app', render: (h) => h(App)

$ FedeauxOrg.initialize
