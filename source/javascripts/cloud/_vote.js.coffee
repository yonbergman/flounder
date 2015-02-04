class VoteCreator
  constructor: (user, party) ->
    vote = new Vote()
    vote.set('target', user)
    vote.set('party', party)
    vote.save()

Parse.Cloud.define "vote", (request, response) ->
  partyId = request.params.party
  userToken = request.params.token

  console.log(partyId)
  console.log(userToken)

  query = new Query(Party)

  Parse.Promise.when([
    Flounder.User.findByWebToken(userToken),
    query.get(partyId),
  ])
  .then(
    (user, party) -> new VoteCreator(user, party)
  ).then(
    (vote) -> response.success('Vote Created', vote.id),
    (obj, err) -> response.error(err)
  )
