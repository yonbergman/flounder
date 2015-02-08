class FriendsVotingController
  friends: ->
    Flounder.loading()
    Flounder.onFacebookReady().then =>
      @_queryFriends()

  _queryFriends: ->
    FB.api('/me/friends', (friends) =>
      friendIds = _.map(friends.data, (friend) =>
        friend.id
      )
      console.log(friendIds)
      query = new Parse.Query(Parse.User)
      query.containedIn("fb_id", friendIds)
      query.find().then(
        (friends) =>
          console.log(friends)
          if !_.isEmpty(friends)
            @_showFriendsPage(friends)
          else
            Flounder.errorPage(message: "מה זה, אין לך חברים")
      )
    )

  _showFriendsPage: (friends) ->
    @friendsView = new FriendsVotingView(friends: friends)
    Flounder.center.show(@friendsView)

FriendsRouter = new Marionette.AppRouter(
  controller: new FriendsVotingController,
  appRoutes: {
    "vote_friends": "friends"
  }
)