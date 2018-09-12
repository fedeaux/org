const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')
const vue =  require('./loaders/vue')
const pug =  require('./loaders/pug')

environment.loaders.append('coffee', coffee)
environment.loaders.append('vue', vue)
environment.loaders.append('pug', pug)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
});

module.exports = environment
