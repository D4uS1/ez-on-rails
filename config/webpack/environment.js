const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')
const typescript =  require('./loaders/typescript')

environment.loaders.prepend('typescript', typescript)
environment.loaders.prepend('coffee', coffee)
module.exports = environment