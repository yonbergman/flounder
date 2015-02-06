class ResultsController
  results: (token) ->
    Flounder.loading()

    if token
      Flounder.User.findByFacebookId(token).then (user) => @_showResultPage(user)
    else if Parse.User.current()
      @_showResultsPage(Parse.User.current())
    else
      Flounder.errorPage()

  _showResultsPage: (user) ->
    unless user
      Flounder.errorPage()
      return
    # parse cloud get results {party: count} for user
    # if results
      # display results
    # else show error page

ResultRouter = new Marionette.AppRouter(
  controller: new ResultsController(),
  appRoutes: {
    "results(/:token)": "results"
  }
)
