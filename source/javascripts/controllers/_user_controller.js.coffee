class @UserController

  isSignedIn: =>
    user = Parse.User.current()
    !!user

  signOut: =>
    Parse.User.logOut()
    Flounder.vent.trigger('user:signed-out user:updated')

  signUpViaFacebook: (promise = new Parse.Promise())=>
    Parse.FacebookUtils.logIn 'user_friends',
      success: (user) =>
        promise.resolve(user)
      error: (user, error) =>
        promise.reject(error)
    promise

  updateUserInfo: (user) =>
    FB.api('/me', (fb_user) =>
      user.set(
        name: fb_user.name
        avatar_url: "http://graph.facebook.com/#{fb_user.id}/picture"
        fb_id: fb_user.id
      )
      user.save()
    )

  signIn: =>
    promise = @signUpViaFacebook()
    promise.done (user) =>
      @updateUserInfo(user)
      Flounder.vent.trigger('user:signed-in user:updated')
    promise


Flounder.userController = new UserController()
Flounder.signOut = Flounder.userController.signOut
Flounder.signIn = Flounder.userController.signIn
Flounder.isSignedIn = Flounder.userController.isSignedIn