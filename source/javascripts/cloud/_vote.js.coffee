class VoteCreator
  constructor: (user, party, voter) ->
    if !user or !party
      return Parse.Promise.error()
    vote = new Vote()
    vote.set('target', user)
    vote.set('party', party)
    vote.set('voter', voter)
    vote.save()

Parse.Cloud.define "vote", (request, response) ->
  partyId = request.params.party
  userToken = request.params.token
  voter = request.user

  console.log(partyId)
  console.log(userToken)

  query = new Parse.Query(Party)

  Parse.Promise.when([
    Flounder.User.findByWebToken(userToken),
    query.get(partyId),
  ])
  .then(
    (user, party) -> new VoteCreator(user, party, voter)
  ).then(
    (vote) -> response.success('Vote Created', vote.id),
    (obj, err) -> response.error(err)
  )
