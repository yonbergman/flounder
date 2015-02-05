class @SignInView extends Marionette.ItemView
  template: 'home/sign_in'
  className: 'col-sm-4 col-sm-offset-4 col-xs-12'

  ui:
    btn: '.sign-in'
    btnDefault: '.sign-in .default'
    btnLoading: '.sign-in .loading'

  events:
    'click @ui.btn': 'signIn'

  signIn: ->
    return if @ui.btn.hasClass('disabled')
    @disableBtn()
    Flounder.signIn()

  disableBtn: ->
    @ui.btn.addClass('disabled')
    @ui.btnDefault.hide()
    @ui.btnLoading.show().removeClass('hidden')
