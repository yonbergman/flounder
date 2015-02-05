class @ToolbarView extends Marionette.ItemView
  template: 'toolbar'
  el: ".toolbar"

  events: ->
    'click .sign-in': '_signIn'
    'click .sign-out': '_signOut'

  initialize: ->
    @listenTo(Flounder.vent, 'user:updated', @setModelAndRender)
    @model = Parse.User.current()

  setModelAndRender: ->
    @model = Parse.User.current()
    @render()

  _signIn: ->
    Flounder.signIn()

  _signOut: ->
    Flounder.signOut()
