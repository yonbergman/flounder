class @UserController

  constructor: ->
    @userView = new UserView()
    @userView.render()
    @userView.on('sign-in', @signIn)
    @userView.on('sign-out', @signOut)

  signOut: =>
    Parse.User.logOut()
    @userView.render()
    window.location.reload()

  signIn: =>
    Parse.FacebookUtils.logIn null,
      success: (user) =>
        FB.api('/me', (fb_user) =>
          user.save(
            first_name: fb_user.first_name
            last_name: fb_user.last_name
            display_name: fb_user.name
            avatar: "http://graph.facebook.com/#{fb_user.id}/picture"
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