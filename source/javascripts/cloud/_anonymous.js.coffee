Parse.Cloud.define "anonymousLogin", (request, response) ->
  Parse.Cloud.useMasterKey()
  if request.user
    response.error("Already Signed In")
    return
  user = new Parse.User();
  user.set('username', secureRandom.randomString(20))
  user.set("password", secureRandom.randomString(20));
  user.set("anonymous", true);
  user.signUp().then(
    (user) ->
      if (user)
        response.success(user.getSessionToken())
      else
        response.error("could not create user")
    ,
    (error) ->
      response.error(error)
  )


moveVotes = (from, to) ->
  unless to
    return new Parse.Promise.error("no target user")
  promise = new Parse.Promise()
  query = new Parse.Query(Vote)
  query.equalTo("voter", from)
  query.find().then(
    (votes) ->
      console.log("found votes")
      console.log(votes)
      promises = []
      votes.forEach( (vote) ->
        console.log(vote.get('target'))
        console.log(vote.get('party'))
        console.log(to)
        subpromise = Flounder.VoteCreator.vote(vote.get('target'), vote.get('party'), to)
        subpromise.then =>
          vote.destroy()
        promises.push(subpromise)
      )
      console.log(promises)
      Parse.Promise.when(promises).then( =>
        console.log("moved")
        promise.resolve()
      )
  )
  promise

Parse.Cloud.define "anonymousLinking", (request, response) ->
  Parse.Cloud.useMasterKey()
  unless request.user && request.user.get('anonymous')
    response.error('cant link non anonymous users')
    return
  unless request.params.facebook
    response.error('need facebook data')
    return

  console.log("start")
  Flounder.User.findByFacebookId(request.params.facebook.id).then(
    (user) =>
      console.log("found FB User")
      moveVotes(request.user, user).always(
        =>
          console.log("Moved votes")
          request.user.destroy().always(
            =>
            console.log("Deleted User")
            response.success("done")
          )
      )
  )
