const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')
const typescript =  require('./loaders/typescript')

environment.loaders.prepend('typescript', typescript)
environment.loaders.prepend('coffee', coffee)

const webpack = require('webpack')
environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
}))

module.exports = environment
