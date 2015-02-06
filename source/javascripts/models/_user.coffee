@Flounder ||= {}
class Flounder.User extends Parse.User
  @findByFacebookId: (token) ->
    query = new Parse.Query(Parse.User)
    query.equalTo("fb_id", token)
    query.first()