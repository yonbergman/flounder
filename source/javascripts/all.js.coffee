#= require 'jquery'
#= require 'underscore'
#= require 'backbone'
#= require 'backbone.marionette'
#= require 'bootstrap'
#= require_tree './vendor'
#= require_tree './models'
#= require_self

window.Flounder = new Marionette.Application()
window.Flounder.addRegions(
    top: '.top'
    main: '.center'
)
Flounder.Models = {}
Flounder.Views = {}
Flounder.Controllers = {}

Flounder.addInitializer (options) ->
    Backbone.history.start();

