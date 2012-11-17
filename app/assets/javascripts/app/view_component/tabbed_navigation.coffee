class AP.view.TabbedNavigation extends AP.view.BasePage
  className: 'ap-tabbed-navigation'
  footerTemplate: '''
    <div class="{{ baseName }}" data-role="footer" data-id="ap-footer" data-position="fixed" data-tap-toggle="false">
      <div data-role="navbar">
        <ul></ul>
      </div>
    </div>
  '''
  navbarItemTemplate: '''
    <li>
      <a href="#" data-page="{{ id }}" data-icon="custom" class="ap-has-icon-{{ icon }}">
        <span>
          <span>{{ name }}</span>
        </span>
      </a>
    </li>
  '''
  events:
    'click a[data-page]': 'tabClick'
  # All my children are belong to us.
  addChildComponent: (instance) ->
    super
    instance.pageId = @viewName
  render: ->
    @footerTemplate = @footerTemplate.replace('{{ baseName }}', @baseName ) if @baseName
    super
    # auto-select first tab on first render
    if !@rendered
      setTimeout (() => @showChild(@constructor.childComponentNames[0])), 300
  renderHeader: ->
    # pass: tabbed nav shouldn't show its own heading, just that of its children
  renderMoreTab: ->
    i = 0
    authIndex = 0
    moreIndex = 0
    pagesList = []
    for viewName, child of @children
      if AP.auth.Authorization.isAuthorized(child.constructor.authRules)
        if authIndex >= 4 and @authorizedChildSize() > 5
          childTitle = child.renderTextFromInstance(child.title)
          pagesList.push "<li><a href=\"#\" data-id=\"#{viewName}\"><div class=\"ap-icon-more-pages ap-icon-#{child.icon}\"></div><h3 class=\"ap-label\">#{childTitle}</h3></a></li>"
          moreIndex = i if !moreIndex
        authIndex++
      i++
    if moreIndex
      # TODO: generate a more pages page
      tabs = @
      class MorePage extends AP.view.BasePage
        @viewName: 'MorePage'
        @application: tabs.constructor.application
        @childComponentNames: []
        @configurationComponentNames: []
        @authRules: []
        icon: 'more'
        tabbedNavigation: tabs
        bodyTemplate: "<div data-role=\"body\"><div class=\"ap-list\"><ul data-role=\"listview\" data-inset=\"true\">#{pagesList.join(' ')}</ul></div></div>"
        events:
          'click [data-role="header"] [data-role="back"]': 'back'
          'click [data-role="listview"] a': 'clickPage'
        show: =>
          @previousPage = AP.view.BasePage.getCurrentPage()
          super
        back: =>
          @tabbedNavigation.showChild(@previousPage.constructor.viewName)
        clickPage: (e) =>
          viewName = $(e.currentTarget).attr('data-id')
          @tabbedNavigation.showChild(viewName)
      @morePage = new MorePage
      @constructor.childComponentNames.splice moreIndex, 0, @morePage.constructor.viewName
      @children[@morePage.constructor.viewName] = @morePage
  renderFooter: ->
    super
    @renderMoreTab()
    
    authIndex = 0
    for name in @constructor.childComponentNames
      child = @children[name]
      if AP.auth.Authorization.isAuthorized(child.constructor.authRules) and (authIndex < 5)
        authIndex++
        $('[data-role="footer"] ul', @el).append(@navbarItemTemplate
          .replace('{{ id }}', child.constructor.viewName)
          .replace('{{ name }}', child.renderTextFromInstance(child.title or '&nbsp;'))
          .replace('{{ icon }}', child.icon))
    
    footerClone = $('[data-role="footer"]', @el).clone().wrap('<div>').parent().html()
    for name, child of @children
      childFooter = $(footerClone).clone()
      $('a[data-page]', childFooter)
        .bind('click', @proxy(@tabClick))
        .removeClass('ui-btn-active')
        .filter("[data-page=\"#{child.constructor.viewName}\"]")
        .addClass('ui-btn-active')
      child.footerTemplate = childFooter
  tabClick: (e) ->
    @showChild($(e.currentTarget).attr('data-page'))
    false
  showChild: (viewName) ->
    options =
      record: true
    if (@constructor.childComponentNames.indexOf(viewName) < @constructor.childComponentNames.indexOf($('.ui-btn-active', @el).attr('data-page')))
      options.reverse = true
    if viewName == 'MorePage'
      options.reverse = false
      @morePage.show(options) if @morePage
    else
      @children[viewName].show(options)
    # globally fix all footer "active" buttons, because jquery mobile gets it
    # wrong consistently
    $('a[data-page]')
      .removeClass('ui-btn-active')
      .filter("[data-page=\"#{viewName}\"]")
      .addClass('ui-btn-active')
  authorizedChildSize: ->
    size = 0
    for name, child of @children
      size++ if AP.auth.Authorization.isAuthorized(child.constructor.authRules)
    return size
