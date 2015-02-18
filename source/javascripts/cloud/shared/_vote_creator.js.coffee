class Flounder.VoteCreator
  @vote: (user, party, voter, voteKey) ->
    if !user or !party or !(voter or voteKey)
      return Parse.Promise.error('Missing variables')
    if voter and voter == user
      return Parse.Promise.error("Can't vote for yourself")

    @checkExistingVote(user, voter, voteKey).done(
      ->
        vote = new Vote()
        vote.set('target', user)
        vote.set('party', party)
        vote.set('voter', voter)
        vote.set('voteKey', voteKey)
        vote.save()
    )

  @checkExistingVote: (user, voter, voteKey)->
    q = new Parse.Query(Vote).equalTo('target', user).equalTo('voteKey', voteKey)
    if voter
      q = Parse.Query.or(
        new Parse.Query(Vote).equalTo('target', user).equalTo('voter', voter),
        q
      )
    q.first().then(
      (vote) ->
        if vote
          return Parse.Promise.error(vote)
        else
          return Parse.Promise.as("no vote")
    )

