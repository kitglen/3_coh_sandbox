# Page component superclasses
# The following classes should be subclassed by page component model classes.
class AP.view.BasePage extends AP.view.Component
  className: 'ap-page'
  template: '<div data-role="page"></div>'
  headerTemplate: '<div data-role="header" data-position="fixed" data-tap-toggle="false"><h1>{{ name }}</h1></div>'
  backButtonTemplate: '<a href="#" class="ap-back" data-role="back" data-icon="arrow-l">Back</a>'
  bodyTemplate: '<div data-role="body"></div>'
  footerTemplate: '<div data-role="footer"></div>'
  @getCurrentPage: ->
    $('.ui-page-active')[0].component
  events:
    'click [data-role="header"] [data-role="back"]': 'back'
  show: (options) ->
    options ?= {}
    if AP.auth.Authorization.isAuthorized(@constructor.authRules)
      @renderOnce()
      # If we're going in reverse, don't change previous page since it creates
      # a history loop.  But always do set it at least initially and when
      # options specifically request the previous page be recorded.
      if (!@previousPage or (!options.reverse or options.record)) and AP.view.BasePage.getCurrentPage()
        @previousPage = AP.view.BasePage.getCurrentPage()
      $.mobile.changePage($(@el), options)
      @update() if @update
      @trigger 'show'
      child.trigger('show') for id, child of @children
      for name, child of @children
        child.update() if child.update
  render: ->
    if !@rendered
      # If page element wasn't handed to this instance, create it.
      # Note:  pages are self-appending since they must not be appended to their
      # parents but rather directly to the document's body.
      if !$(@el).is('[data-role="page"]')
        @replace($(@template)[0])
        $(@el).attr('data-id', @pageId) if @pageId
        $('body').append(@el)
      # Render sections.
      @renderHeader()
      @renderBody()
      @renderFooter()
      # If page has children, append them, being careful not to append any
      # page-type components, since they are self-appending.
      for id, child of @children
        if !(child instanceof AP.view.BasePage)
          $('[data-role="body"]', @el).append(child.el)
          child.show()
      # If page has form configuration components, append them because they are
      # equivalent to chidlren.
      for id, config of @configuration
        if config instanceof AP.view.BaseForm
          $('[data-role="body"]', @el).append(config.el)
          config.show()
      super
  renderHeader: ->
    header = $(@renderTextFromInstance(@headerTemplate.replace(/{{ name }}/g, @title or '')))
    $(@el).append(header)
    if @showBackButton
      $(@backButtonTemplate).insertBefore($('h1', header))
    if @title_bar_button_id
      for name, config of @configuration
        if config.id == @title_bar_button_id
          $(config.el).insertBefore($('h1', header))
          config.show()
  renderBody: ->
    $(@el).append(@bodyTemplate)
  renderFooter: ->
    $(@el).append(@footerTemplate)
  showNoDataMessage: ->
    $('[data-role="body"] *', @el).css({visibility: 'hidden'})
    $('.ap-no-data', @el).css({display: '', visibility: ''})
    if !$('.ap-no-data', @el).size()
      $('[data-role="body"]', @el).prepend '<div class="ap-no-data">No data available.</div>'
  unrender: ->
    # go back a page if this page is showing
    if (@ == AP.view.BasePage.getCurrentPage()) and @previousPage
      @previousPage.show()
    for id, child of @children
      child.unrender()
      # If page has form configuration components, unrender them too because
      # they are equivalent to chidlren.
    for id, config of @configuration
      if config instanceof AP.view.BaseForm
        config.unrender()
    super
  hasBack: ->
    !!@previousPage
  back: ->
    @previousPage.show({reverse: true}) if @previousPage
