class @VotedView extends Marionette.LayoutView
  template: 'voted'
  regions:
    card: '.card-region'

  onShow: ->
    partyView = new PartyView(model: @model, className: 'party-card disabled')
    @card.show(partyView)

