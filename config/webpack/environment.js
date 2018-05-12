const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')
const vue =  require('./loaders/vue')
const pug =  require('./loaders/pug')
const sass =  require('./loaders/sass')

environment.loaders.append('coffee', coffee)
environment.loaders.append('vue', vue)
environment.loaders.append('pug', pug)
environment.loaders.append('sass', sass)
module.exports = environment
