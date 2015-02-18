Parse.Cloud.define "vote", (request, response) ->
  partyId = request.params.party
  fb_id = request.params.target
  voteKey = request.params.voteKey
  voter = request.user

  query = new Parse.Query(Party)

  Parse.Promise.when([
    Flounder.User.findByFacebookId(fb_id),
    query.get(partyId),
  ])
  .then(
    (user, party) -> Flounder.VoteCreator.vote(user, party, voter, voteKey)
  ).fail(
    (err) -> response.error(err)
  ).done(
    (vote) -> response.success('Vote Created', vote.id),
  )


Parse.Cloud.define "didVote", (request, response) ->
  fb_id = request.params.target
  voteKey = request.params.voteKey
  voter = request.user

  Flounder.User.findByFacebookId(fb_id).then(
    (user) -> Flounder.VoteCreator.checkExistingVote(user, voter, voteKey)
  ).done(
    -> response.success()
  ).fail(
    (vote) -> response.error(vote)
  )