class @Party extends Parse.Object
  className: 'Party'

class @Parties extends Parse.Collection
  model: Party

  comparator: (party) ->
    party.get('name')
