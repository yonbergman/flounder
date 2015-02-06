class @FriendsVotingView extends Marionette.LayoutView
  template: 'friends_voting'
  regions:
    friendsSelector: '.friends'
  
  initialize: (options) ->
    @friends = options.friends

  templateHelpers: ->
    friends: @friends