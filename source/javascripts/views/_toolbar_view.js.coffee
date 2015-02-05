class @ToolbarView extends Marionette.ItemView
  template: 'toolbar'
  el: ".toolbar"

  events: ->
    'click .sign-in': '_signIn'
    'click .sign-out': '_signOut'

  initialize: ->
    @userChannel = Backbone.Wreqr.radio.channel('user');
    @listenTo(@userChannel.vent, 'user:updated', @setModelAndRender)
    @model = Parse.User.current()

  setModelAndRender: ->
    @model = Parse.User.current()
    @render()

  _signIn: ->
    console.log("EG")
    @userChannel.commands.execute('sign-in')

  _signOut: ->
    @userChannel.commands.execute('sign-out')
