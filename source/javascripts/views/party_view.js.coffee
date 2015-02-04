class @PartyView extends Marionette.ItemView
  template: "party"
  className: 'party party-card'

class @PartiesView extends Marionette.CollectionView
  childView: PartyView
  className: 'parties'