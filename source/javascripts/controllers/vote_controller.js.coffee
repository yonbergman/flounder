class VoteController
  vote: (token) ->
    Flounder.center.show(new LoadingView())
    Flounder.User.findByWebToken(token).then(
      (targetUser) => @_showVotePage(targetUser)
      (error) => Flounder.center.empty(),
    )

  _showVotePage: (user) ->
    Flounder.center.show(new VoteView(model: user))


VoteRouter = new Marionette.AppRouter(
  controller: new VoteController,
  appRoutes: {
    "vote/:token": "vote"
  }
)
