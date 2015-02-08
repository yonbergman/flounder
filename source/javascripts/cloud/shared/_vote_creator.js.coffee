class Flounder.VoteCreator
  @vote: (user, party, voter) ->
    if !user or !party or !voter
      return Parse.Promise.error('missing variables')
    #TODO: validate no other vote exists for target/voter pair
    #TODO: validate target != voter
    vote = new Vote()
    vote.set('target', user)
    vote.set('party', party)
    vote.set('voter', voter)
    vote.save()