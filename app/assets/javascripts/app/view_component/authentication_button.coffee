class AP.view.AuthenticationButton extends AP.view.BaseButton
  className: 'ap-authentication-button'
  constructor: ->
    super
    if AP.auth.Authentication.isAuthenticated()
      @title = @authenticated_title or ''
  getLoginPage: ->
    _this = @
    class LoginPage extends AP.view.BasePage
      @viewName: 'LoginPage'
      @application: _this.constructor.application
      @childComponentNames: []
      @configurationComponentNames: []
      @authRules: []
      parent: _this
      name: _this.title or ''
      className: 'ap-login-page'
      showBackButton: true
      events:
        'click .ap-logout-link': 'logout'
        'click [data-role="header"] [data-role="back"]': 'back'
      constructor: ->
        super
        baseName = @parent.constructor.baseName
        formId = "#{baseName}-login-form"
        if !AP.auth.Authentication.isAuthenticated()
          loginForm = new (@getLoginFormClass())
          @addChildComponent(loginForm)
        else
          @children['label'] = new AP.view.Label
            id: 'label'
            content: '<p>Already logged in. <a href="#" class="ap-logout-link">Logout?</a></p>'
            parent: @
          @delegateEvents() if @events
      login: (credentials) ->
        $.mobile.showPageLoadingMsg()
        AP.auth.Authentication.login credentials
      logout: ->
        $.mobile.showPageLoadingMsg()
        AP.auth.Authentication.logout()
      getLoginFormClass: ->
        _this = @
        class LoginForm extends AP.view.BaseForm
          @viewName: 'LoginForm'
          @application: _this.constructor.application
          @childComponentNames: []
          @configurationComponentNames: []
          @authRules: []
          parent: _this
          getModel: -> @parent.parent.getApp().getModel(@parent.parent.authenticatable_object_id)
          getFields: ->
            model = AP.auth.Authentication.getAuthenticatableObject()
            lookup:
              name: model.lookup_field
              label: model.lookup_field
              type: 'string'
            match:
              name: model.match_field
              label: model.match_field
              type: 'password'
          save: ->
            data = {}
            model = AP.auth.Authentication.getAuthenticatableObject()
            data[model.lookup_field] = $("[name=\"#{model.lookup_field}\"]", @el).val()
            data[model.match_field] = $("[name=\"#{model.match_field}\"]", @el).val()
            @parent.login data
  click: (e) ->
    baseName = @constructor.baseName
    isAuthenticated = AP.auth.Authentication.isAuthenticated()
    pageId = "#{baseName}-login-page"
    if !isAuthenticated
      loginPage = new (@getLoginPage())
      @addChildComponent(loginPage)
      loginPage.show()
    if isAuthenticated
      $.mobile.showPageLoadingMsg()
      AP.auth.Authentication.logout()
