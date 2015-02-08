class FacebookContainer
  constructor: ->
    @fb = null
    Flounder.vent.on("fb:ready", (fb) =>
      @fb = fb
    )

  onFacebookReady: ->
    promise = new Parse.Promise()
    if @fb
      promise.resolve(@fb)
    else
      Flounder.vent.on('fb:ready', (fb) =>
        promise.resolve(fb)
      )
    return promise;

facebookContainer = new FacebookContainer()
Flounder.onFacebookReady = facebookContainer.onFacebookReady
