class AP.view.UpdateObjectFormPage extends AP.view.BasePage
  className: 'ap-update-object-form-page'
  constructor: ->
    super
    _this = @
    baseName = @constructor.baseName
    viewClassName = "#{@constructor.viewName}UpdateForm"
    class UpdateForm extends AP.view.ObjectInstanceForm
      @application: _this.constructor.application
      @viewName: viewClassName
      @baseName: "#{baseName}-create-form"
      @childComponentNames: []
      @configurationComponentNames: _this.constructor.configurationComponentNames
      parent: _this
      datasource_id: _this.datasource_id
      object_definition_id: _this.object_definition_id
      object_form_field_ids: _this.object_form_field_ids
      success_page_id: _this.success_page_id
      success_action: _this.success_action
      failure_action: _this.failure_action
      success_message: _this.success_message
      failure_message: _this.failure_message
    @updateFormClass = UpdateForm
  render: ->
    form = new (@updateFormClass)
    form.configuration = @configuration
    form.instance = @instance
    @addChildComponent(form)
    super
