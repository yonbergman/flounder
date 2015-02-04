#= require 'jquery'
#= require 'underscore'
#= require 'backbone'
#= require 'backbone.marionette'
#= require 'bootstrap'
#= require_tree './vendor'
#= require_tree './models'
#= require_tree './views'
#= require_tree './templates'
#= require_self

window.Flounder = new Marionette.Application()
window.Flounder.addRegions(
    top: '.top-row'
    main: '.center'
    footer: '.footer'
)
Flounder.Models = {}
Flounder.Views = {}
Flounder.Controllers = {}?

Flounder.addInitializer (options) ->
    Backbone.history.start();

    Flounder.footer.show(new FooterView())

