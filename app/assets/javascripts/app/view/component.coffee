class AP.view.Component extends AP.view.View
  @getChildren: ->
    'Returns an array of view classes that are children of this component.'
    (@getApp().getView(name) for name in @childComponentNames)
  @getConfiguration: ->
    'Returns an array of view classes that are configuration of this component.'
    (@getApp().getView(name) for name in @configurationComponentNames)
  className: 'ap-component'
  constructor: ->
    super
    @logPrefix = "(#{@viewName})"
    @children = {}
    @configuration = {}
    app = @getApp()
    # Children components are contained by their component.
    for viewClass in @constructor.getChildren()
      @addChildComponent(new (viewClass)()) if viewClass
    # Configuration components are used by but not children of their component.
    for viewClass in @constructor.getConfiguration()
      @addConfigurationComponent(new (viewClass)()) if viewClass
    if @objectDefinitionId
      @getApp().getModel(@objectDefinitionId).bind 'create update', @proxy =>
        @getQueryScope().load() if @getQueryScope
        @renderListItems() if @renderListItems
  addChildComponent: (instance) ->
    @children[instance.constructor.viewName] = $.extend(instance, {parent: @})
  addConfigurationComponent: (instance) ->
    @configuration[instance.constructor.viewName] = $.extend(instance, {owner: @})
  show: ->
    if AP.auth.Authorization.isAuthorized(@constructor.authRules)
      @renderOnce()
      $(@el).show()
      @trigger 'show'
      child.trigger('show') for name, child of @children
  hide: -> $(@el).hide()
  renderOnce: ->  
    if !@rendered 
      @render()
      @rendered = true
      if @unrendered
        @unrendered = false
        @delegateEvents() if @events
        @refreshElements() if @elements
  render: ->
    $(@el)[0].component = @
    $(@el).addClass(@className) if @className
    $(@el).addClass(@constructor.baseName) if @constructor.baseName
  getObjectFieldIds: ->
    fields = @object_field_ids
    fields
  getInstanceData: ->
    if @instance and @object_field_ids
      @instance.attributesByFieldIds(@getObjectFieldIds())
    else if @instance
      @instance.toJSON()
    else
      {}
  renderTextFromRecord: (text, record) ->
    fields = if (record and record.constructor and record.constructor.fieldDefinitionsByName) then record.constructor.fieldDefinitionsByName() else {}
    data = if (record and record.toJSON) then record.toJSON() else record or {}
    user = AP.auth.Authentication.getAuthSessionData()
    for name, value of data
      proccessedValue = if (fields[name] and fields[name].file_url and (fields[name].file_type == 'Image')) then "<img src=\"#{value}\" />" else value
      (text = text.replace(RegExp("{{#{name}}}", 'g'), proccessedValue))
    for name, value of user
      proccessedValue = if (fields[name] and fields[name].file_url and (fields[name].file_type == 'Image')) then "<img src=\"#{value}\" />" else value
      (text = text.replace(RegExp("{{user.#{name}}}", 'g'), proccessedValue))
    text.replace(/({{[\w\d]+}})/g, '')
  renderTextFromInstance: (text) ->
    @renderTextFromRecord text, @instance
  unrender: ->
    if @rendered
      # remove the element
      @replace('<div />')
      # and reset the rendered flag
      @rendered = false
      @unrendered = true
  refreshElements: ->
    for selector, name of @elements
      @[name] = $(selector, @el)
  hideNoDataMessage: ->
    $('*', @el).css({visibility: ''})
    $('.ap-no-data', @el).css({display: 'none'})
  showNoDataMessage: ->
    $('*', @el).css({visibility: 'hidden'})
    $('.ap-no-data', @el).css({display: '', visibility: ''})
    if !$('.ap-no-data', @el).size()
      $(@el).prepend '<div class="ap-no-data">No data available.</div>'
