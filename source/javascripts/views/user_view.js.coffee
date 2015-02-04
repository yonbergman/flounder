class @UserView extends Marionette.ItemView
  template: 'user'

  events:
    'click a': (ev) -> ev.preventDefault()

  triggers:
    'click #sign-in': 'sign-in'
    'click #sign-out': 'sign-out'