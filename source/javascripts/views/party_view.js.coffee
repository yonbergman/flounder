class @PartyView extends Marionette.ItemView
  template: "party"
  className: 'party'

class @PartiesView extends Marionette.CollectionView
  childView: PartyView