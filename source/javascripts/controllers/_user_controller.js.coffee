class @UserController
  constructor: ->
    @anonymousLogin()

  isSignedIn: =>
    user = Parse.User.current()
    user && !user.get('anonymous')

  signOut: =>
    Parse.User.logOut()
    Flounder.vent.trigger('user:signed-out user:updated')

  signIn: =>
    debugger
    promise = new Parse.Promise()
    if Parse.User.current()
      fbPromise = new Parse.Promise()
      Parse.FacebookUtils.link(Parse.User.current(), 'user_friends'
        success: (user) ->
          fbPromise.resolve(user)
        error: (user, error, foo) =>
          console.log(":(", user, error)
          window.bar = [user, error, foo]
          if error.code == 208
            authData = user.get('authData').facebook
            @linkAnonymousAccount(fbPromise, authData)
          fbPromise.reject(error)
      )
      Parse.User.current().set('anonymous', false)
    else
      fbPromise = Parse.FacebookUtils.logIn 'user_friends'
    fbPromise.then(
      (user) =>
        FB.api('/me', (fb_user) =>
          user.save(
            name: fb_user.name
            avatar_url: "http://graph.facebook.com/#{fb_user.id}/picture"
            fb_id: fb_user.id
          )
          Flounder.vent.trigger('user:signed-in user:updated')
          promise.resolve(user)
        )
      ,
      (user, error) ->
        console.error("User cancelled the Facebook login or did not fully authorize.")
        promise.reject(error)
    )
    promise

  linkAnonymousAccount: (promise, authData) =>
    Parse.Cloud.run('anonymousMerge', authData).then(
      (sessionToken) ->
        if sessionToken
          Parse.User.become(sessionToken)
          promise.resolve(Parse.User.current())
        else
          promise.reject("could not merge")
      ,
      (error) ->
        promise.reject(error)
    )


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