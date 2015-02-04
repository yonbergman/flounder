class VoteController
  vote: (token) ->
    Flounder.center.show(new LoadingView())
    @parties = new Parties()

    Parse.Promise.when([
      Flounder.User.findByWebToken(token),
      @parties.fetch(),
    ])
    .then(
      (user, parties) =>
        if user
          @_showVotePage(user, parties)
        else
          @_showErrorPage()
    )

  _showErrorPage: ->
    Flounder.center.empty()

  _showVotePage: (user, parties) ->
    @voteView = new VoteView(model: user, collection: parties)
    @voteView.on('select-party', (party) =>
      @_selectParty(user, party)
    )
    Flounder.center.show(@voteView)

  _selectParty: (user, party) ->
    @voteView.focusOn(party)
    Parse.Cloud.run('vote', {
      token: user.get('url_token'),
      party: party.id
    }).then(
      (done) =>
        console.log("Voted")
        @voteView.voted(party)
    )


VoteRouter = new Marionette.AppRouter(
  controller: new VoteController,
  appRoutes: {
    "vote/:token": "vote"
  }
)
