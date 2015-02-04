class @VoteView extends Marionette.LayoutView
  template: 'vote'
  regions:
    userInfo: '.voter-target'
    partySelector: '.party-selector'

  onShow: ->
    @userInfo.show(new UserInfoView(model: @model))