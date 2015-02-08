class @UserController
  constructor: ->
    @anonymousLogin()

  isSignedIn: =>
    user = Parse.User.current()
    user && !user.get('anonymous')

  signOut: =>
    Parse.User.logOut()
    Flounder.vent.trigger('user:signed-out user:updated')
    @anonymousLogin()


  signInViaFacebook: (promise = new Parse.Promise()) =>
    promise = new Parse.Promise()
    Parse.FacebookUtils.link Parse.User.current(), 'user_friends',
      success: (user) =>
        promise.resolve(user)
      error: (user, error) =>
        if error.code == 208 # user already linked
          Parse.Cloud.run('anonymousLinking', user.get('authData'))
          @signUpViaFacebook(promise)
        else
          promise.reject(error)
    promise

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
        anonymous: false
      )
      user.save()
    )

  signIn: =>
    if Parse.User.current()
      promise = @signInViaFacebook()
    else
      promise = @signUpViaFacebook()
    promise.done (user) =>
      @updateUserInfo(user)
      Flounder.vent.trigger('user:signed-in user:updated')
    promise

  anonymousLogin: =>
    return if Parse.User.current()?
    Parse.Cloud.run('anonymousLogin').then(
      (sessionToken) ->
        if sessionToken
          Parse.User.become(sessionToken)
    )


Flounder.userController = new UserController()
Flounder.signOut = Flounder.userController.signOut
Flounder.signIn = Flounder.userController.signIn
Flounder.isSignedIn = Flounder.userController.isSignedIn