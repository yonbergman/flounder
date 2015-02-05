class @UserController

  constructor: ->
    @userView = new UserView()
    @userView.render()
    Flounder.center.show(@userView)
    @userView.on('sign-in', @signIn)
    @userView.on('sign-out', @signOut)

  signOut: =>
    Parse.User.logOut()
    @userView.render()
    window.location.reload()

  signIn: =>
    Parse.FacebookUtils.logIn 'user_friends',
      success: (user) =>
        FB.api('/me', (fb_user) =>
          user.save(
            name: fb_user.name
            avatar_url: "http://graph.facebook.com/#{fb_user.id}/picture"
          )
          @userView.render()
        )
        if user.get('avatar')?
          @userView.render()
        user.setACL(new Parse.ACL(user));

      error: (user, error) ->
        console.log("User cancelled the Facebook login or did not fully authorize.")

Flounder.addInitializer (options) ->
  Flounder.userController = new UserController()