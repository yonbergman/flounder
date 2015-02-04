@Flounder ||= {}
class Flounder.User extends Parse.User
  @findByWebToken: (token) ->
    query = new Parse.Query(Parse.User)
    query.equalTo("url_token", token)
    query.first()