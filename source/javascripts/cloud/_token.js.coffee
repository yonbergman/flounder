Parse.Cloud.beforeSave Flounder.User, (request, response) ->
  user = request.object
  if !user.existed() or !user.has('url_token')
    user.set('url_token', secureRandom.randomString(10))
  response.success()
