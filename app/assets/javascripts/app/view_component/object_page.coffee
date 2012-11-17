class AP.view.ObjectPage extends AP.view.BasePage
  className: 'ap-object-page'
  showBackButton: true
  constructor: ->
    super
    _this = @
    baseName = @constructor.baseName
    viewClassName = "#{@constructor.viewName}ObjectForm"
    class ObjectForm extends AP.view.ObjectInstanceForm
      @application: _this.constructor.application
      @viewName: viewClassName
      @baseName: "#{baseName}-object-form"
      @childComponentNames: []
      @configurationComponentNames: []
      datasource_id: _this.datasource_id
      object_definition_id: _this.object_definition_id
      parent: _this
      datasource_id: _this.datasource_id
      object_form_field_ids: _this.object_form_field_ids or _this.object_field_ids
      readOnly: true
    @objectFormClass = ObjectForm
  render: ->
    if @instance
      # render the title
      @titleTemplate ?= @title or ''
      @title = @renderTextFromRecord(@titleTemplate or @title, @instance)
    form = new (@objectFormClass)
    form.configuration = @configuration
    form.instance = @instance
    @addChildComponent(form)
    super
