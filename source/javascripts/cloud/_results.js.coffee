class ResultCounter
  @count: (votes) ->
    total = 0
    partyCounter = {}
    parties = {}

    votes.forEach (vote) ->
      party = vote.get('party')
      key = party.id
      parties[key] = party
      count = if partyCounter[key] then partyCounter[key] else 0
      partyCounter[key] = count + 1
      total += 1

    results = []
    for partyKey, count of partyCounter
      results.push(
        party: parties[partyKey].toJSON()
        count: count
        percent: Math.round(100 * count / total)
      )
    results

Parse.Cloud.define "results", (request, response) ->
  if !request.user
    response.error("not signed in")
  q = new Parse.Query(Vote)
  q.equalTo("target", request.user)
  q.include('party')
  q.find().then(
    (votes) ->
      response.success(ResultCounter.count(votes))
  )