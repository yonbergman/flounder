class @VoteView extends Marionette.LayoutView
  template: 'vote'
  regions:
    userInfo: '.voter-target'
    partySelector: '.party-selector'

  onShow: ->
    @userInfo.show(new UserInfoView(model: @model))
    partyView = new PartiesView(collection: @collection)
    @partySelector.show(partyView)
    partyView.on('childview:select', (partyView) =>
        @trigger('select-party', partyView.model)
    )