Parse.Cloud.define "results", (request, response) ->
  if !request.user
    response.error("not signed in")
  q = new Parse.Query(Vote)
  q.equalTo("target", request.user)
  q.find().then(
    (votes) ->
      resultTable = {}
      votes.forEach (vote) ->
        key = vote.get('party').id
        count = if resultTable[key] then resultTable[key] else 0
        resultTable[key] = count + 1
      response.success(resultTable)
  )