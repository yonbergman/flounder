class @HomeView extends Marionette.LayoutView
  template: 'home/home'
  className: 'col-sm-6 col-sm-offset-3 col-xs-12'

  events:
    'click .btn-facebook': 'shareOnFacebook'
    'click .btn-twitter': 'shareOnTwitter'

  serializeModel: (user) =>
    hash = super(user)
    _.extend(hash,
      vote_url: @voteUrl()
    )

  shareOnFacebook: ->
    FB.ui(
      method: 'share',
      href: @voteUrl(),
    )

  shareOnTwitter: ->
    url = encodeURIComponent(@voteUrl())
    text = "מה הרושם הפוליטי שאתה משאיר"
    window.open("https://twitter.com/intent/tweet?text=#{text}&url=#{url}", "", "toolbar=0, status=0, width=650, height=360")


  voteUrl: ->
    location.origin + '#/vote/' + @model.get('url_token')
