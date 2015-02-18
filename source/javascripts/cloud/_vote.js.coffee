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
  ).then(
    (vote) -> response.success('Vote Created', vote.id),
    (obj, err) -> response.error(err)
  )