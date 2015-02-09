class @ResultsView extends Marionette.LayoutView
  template: 'home/results'
  className: 'rtl'

  initialize: ->
    @_getResults()

  _getResults: ->
    Parse.Cloud.run('results').then(
      (results) =>
        @results = results
        @render()
    )

  serializeModel: (user) =>
    hash = super(user)
    _.extend(hash,
      results: _.sortBy((@results || []), 'percent').reverse()
    )