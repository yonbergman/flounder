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


mergeExistingUser = (user, request, response)->
  unless user
    response.error("No user exists")
    return
  unless user.get('authData').facebook.access_token == request.params.access_token
    response.error("incorrect user data")
    return
  q = new Parse.Query(Vote)
  q.equalTo("voter", request.user)
  q.find().then(
    (votes) ->
      if votes && !_.isEmpty(votes)
        votePromises = _.map(votes, (v) ->
          v.set('voter', user)
          v.save()
        )
        votePromises.push(
          request.user.destroy()
        )
        Parse.Promise.when(
          votePromises
        ).then(
          ->
            response.success(user.getSessionToken())
        )
  )


Parse.Cloud.define "anonymousMerge", (request, response) ->
  Parse.Cloud.useMasterKey()
  if !request.user || !request.user.get("anonymous")
    response.error("Must be signed in")
    return
  console.log(request.params)
  Flounder.User.findByFacebookId(request.params.id).then(
    (user) ->
      console.log("HEY", user, request.params.id)
      console.log(user)
      console.log(request.params.id)
      mergeExistingUser(user, request, response)
    ,
    (user, error) ->
      response.error(error)
  )