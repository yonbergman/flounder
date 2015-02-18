class VoteController
  VALID_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";
  VOTE_KEY = '_flounder_votekey'
  constructor: ->
    @_generateVoteId()


  vote: (facebookId) ->
    Flounder.loading()
    @parties = new Parties()

    Parse.Promise.when([
      Flounder.User.findByFacebookId(facebookId),
      @parties.fetch(),
      @_checkIfVoted(facebookId)
    ])
    .then(
      (user, parties, voted, y) =>
        console.log(user, parties, voted, y)
        if user
          @_showVotePage(user, parties)
        else
          Flounder.errorPage(message: "לא נמצא משתמש כזה")
    )

  _showVotePage: (user, parties) ->
    window.model = user
    @voteView = new VoteView(model: user, collection: parties)
    @voteView.on('select-party', (party) =>
      @_selectParty(user, party)
    )
    Flounder.center.show(@voteView)

  _selectParty: (user, party) ->
    @voteView.focusOn(party)
    Parse.Cloud.run('vote', {
      target: user.get('fb_id'),
      party: party.id
      voteKey: @voteKey
    }).done( =>
      console.log("Voted")
      @voteView.voted(party)
    ).fail( (err) =>
      Flounder.errorPage(err)
    )

  _generateVoteId: ->
    voteKey = localStorage.getItem(VOTE_KEY)
    unless voteKey
      voteKey = @_randomID()
      localStorage.setItem(VOTE_KEY, voteKey)
    @voteKey = voteKey

  _randomID: ->
    text = ""
    _(10).times ->
      text += VALID_CHARS.charAt(Math.floor(Math.random() * VALID_CHARS.length));
    text

  _checkIfVoted: (facebookId)->
    Parse.Cloud.run('didVote', {
      target: facebookId,
      voteKey: @voteKey
    })

VoteRouter = new Marionette.AppRouter(
  controller: new VoteController,
  appRoutes: {
    "vote/:facebookId": "vote"
  }
)
