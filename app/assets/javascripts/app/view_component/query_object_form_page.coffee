class AP.view.QueryObjectFormPage extends AP.view.BasePage
  className: 'ap-query-object-form-page'
  constructor: ->
    super
    _this = @
    baseName = @constructor.baseName
    viewClassName = "#{@constructor.viewName}CreateForm"
    class QueryForm extends AP.view.ObjectQueryForm
      @application: _this.constructor.application
      @viewName: viewClassName
      @baseName: "#{baseName}-create-form"
      @childComponentNames: []
      @configurationComponentNames: _this.constructor.configurationComponentNames
      parent: _this
      datasource_id: _this.datasource_id
      object_definition_id: _this.object_definition_id
      object_form_field_ids: _this.object_form_field_ids
      page_id: _this.page_id
    form = new QueryForm
    form.configuration = @configuration
    @addChildComponent(form)
