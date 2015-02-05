class HomeController
  root: ->
    Flounder.vent.on('user:updated', @showHomeForUser)
    @showHomeForUser()

  showHomeForUser: =>
    if Parse.User.current()
      @home()
    else
      @signInPage()

  home: ->
    homeView = new HomeView(model: Parse.User.current())
    Flounder.center.show(homeView)

  signInPage: ->
    signInView = new SignInView()
    Flounder.center.show(signInView)


HomeRouter = new Marionette.AppRouter(
  controller: new HomeController(),
  appRoutes: {
    "": "root"
  }
)
