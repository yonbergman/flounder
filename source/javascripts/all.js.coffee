#= require 'jquery'
#= require 'underscore'
#= require 'backbone'
#= require 'backbone.marionette'
#= require 'bootstrap'
#= require '_fb'
#= require_tree './vendor'

#= require_self
#= require_tree './models'
#= require_tree './views'
#= require_tree './controllers'
#= require_tree './templates'

Parse.initialize("7nX1kpA7n3EX5egUf4DFLiOBOy58onWdWBjZAT45", "y9a3EiVXet885m3H4GJKQ7ZHYwg7TTZhP6rWAETd");

window.Flounder = new Marionette.Application()
window.Flounder.addRegions(
    top: '.top-row'
    center: '.center'
)
Flounder.Models = {}
Flounder.Views = {}
Flounder.Controllers = {}?

Flounder.loading = ->
    Flounder.center.show(new LoadingView())

Flounder.errorPage = (options = {}) ->
    Flounder.center.show(new ErrorView(options))

Flounder.addInitializer (options) ->
    Backbone.history.start();
    window.toolbarView = new ToolbarView().render()