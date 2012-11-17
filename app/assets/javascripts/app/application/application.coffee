class window.COHSdk extends window.COHSdk
  @setup: ->
    @rootViewName = @rootViewName or ''
    @rootViewInstance = @rootViewInstance or null
    @views = {}
  @getView: (str) ->
    'Returns a view with name equal to str.'
    _.find @views, (val, key) -> key == str
  @getRootView: ->
    'Returns the root view class.'
    @getView @rootViewName
  @getRootViewInstance: ->
    'Returns the root view instance.'
    @rootViewInstance
  @authChange: ->
    'Reloads page when an authentication change event occurs (login or logout).'
    window.location.reload()
  @authError: ->
    'Displays an authentication error message in a dialog.'
    class AuthDialog extends AP.view.Dialog
      heading: 'Login'
      content: 'Your login request was not accepted.  Please try again.'
    (new AuthDialog).show()
  @init: ->
    'Initializes the application.  Call only once.'
    AP.auth.Authentication.bind 'auth:authenticated', @proxy(@authChange)
    AP.auth.Authentication.bind 'auth:deauthenticated', @proxy(@authChange)
    AP.auth.Authentication.bind 'auth:error', @proxy(@authError)
    @rootViewInstance = new (@getRootView())
    @rootViewInstance.show()
