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
  fb_id = request.params.target
  voter = request.user

  query = new Parse.Query(Party)

  Parse.Promise.when([
    Flounder.User.findByFacebookId(fb_id),
    query.get(partyId),
  ])
  .then(
    (user, party) -> new VoteCreator(user, party, voter)
  ).then(
    (vote) -> response.success('Vote Created', vote.id),
    (obj, err) -> response.error(err)
  )