import 'style/application.sass'
import TatApp from '../tat.coffee'
import App from 'app.vue'

TatApp.initialize = ->
  el = document.body.appendChild document.createElement 'tatapp'
  new Vue el: el, render: (h) => h(App)

TatApp.initialize()
