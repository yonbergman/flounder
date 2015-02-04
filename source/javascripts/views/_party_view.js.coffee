class @PartyView extends Marionette.ItemView
  template: "party"
  className: 'party party-card'

  triggers:
    'click': 'select'

class @PartiesView extends Marionette.CollectionView
  childView: PartyView
  className: 'parties'