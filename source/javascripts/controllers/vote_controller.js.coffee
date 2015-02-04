class VoteController
  vote: (token) ->
    Flounder.center.show(new LoadingView())
    @parties = new Parties()

    Parse.Promise.when([
      Flounder.User.findByWebToken(token),
      @parties.fetch(),
    ])
    .then(
      (user, parties) => @_showVotePage(user, parties)
      (error) => Flounder.center.empty(),
    )

  _showVotePage: (user, parties) ->
    Flounder.center.show(new VoteView(model: user, collection: parties))


VoteRouter = new Marionette.AppRouter(
  controller: new VoteController,
  appRoutes: {
    "vote/:token": "vote"
  }
)
