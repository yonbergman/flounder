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
    voteView = new VoteView(model: user, collection: parties)
    voteView.on('select-party', (party) =>
      @_selectParty(user, party)
    )
    Flounder.center.show(voteView)

  _selectParty: (user, party) ->
    Parse.function

VoteRouter = new Marionette.AppRouter(
  controller: new VoteController,
  appRoutes: {
    "vote/:token": "vote"
  }
)
