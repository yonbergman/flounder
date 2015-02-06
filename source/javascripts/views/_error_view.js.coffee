class @ErrorView extends Marionette.ItemView
  template: 'error'

  initialize: (@options = {}) ->
    @model = @options

  serializeModel: ->
    @options