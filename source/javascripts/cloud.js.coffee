#= require_tree ./models

Parse.Cloud.define "hello", (request, response) ->
  # response.success("Hello world!");
  console.log(Restaurant.className)
  q = new Parse.Query(Restaurant)
  q.get("foo",
    success: ->
      response.success("YEY")
    error: (obj, err) ->
      response.error(err)
  )
