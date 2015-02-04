class ResultsController
  results: (token) ->
    Flounder.center.show(new LoadingView())

    if (token)
      Flounder.User.findByWebToken(token).then (user) => @_showResultPage(user)
#    else
      # if current user - show results page for current user
    # else
      # show error page
    Flounder.center.empty()

  _showErrorPage: ->
    Flounder.center.empty()

  _showResultsPage: (user) ->
    unless user
      @_showErrorPage()
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
