class @UserController

  signOut: =>
    Parse.User.logOut()
    Flounder.vent.trigger('user:signed-out user:updated')

  signIn: =>
    promise = new Parse.Promise()
    Parse.FacebookUtils.logIn null,
      success: (user) =>
        FB.api('/me', (fb_user) =>
          user.save(
            name: fb_user.name
            avatar_url: "http://graph.facebook.com/#{fb_user.id}/picture"
            fb_id: fb_user.id
          )
          Flounder.vent.trigger('user:signed-in user:updated')
          promise.resolve(user)
        )

      error: (user, error) ->
        console.error("User cancelled the Facebook login or did not fully authorize.")
        promise.reject(error)
    promise

Flounder.addInitializer () ->
  Flounder.userController = new UserController()
  Flounder.signOut = Flounder.userController.signOut
  Flounder.signIn = Flounder.userController.signIn