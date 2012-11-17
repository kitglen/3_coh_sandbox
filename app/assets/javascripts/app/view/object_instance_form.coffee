class AP.view.ObjectInstanceForm extends AP.view.BaseForm
  getSuccessPage: ->
    for name, view of @configuration
      success = view if view.id == @success_page_id
    success
  onSaveFail: (instance) ->
    heading = 'Error'
    message = @failure_message
    if !instance.isValid()
      firstError = instance.errors()[0]
      for field in instance.fieldDefinitions
        if field.name == firstError.field
          message = "#{field.label}:  #{firstError.message}"
    hide = =>
      if @failure_action == 'Back'
        (@owner or @parent).back()
      else if @failure_action == 'Stay Put'
        $.mobile.changePage($(dialog.previousPage.el), {reverse: true})
    if message
      class FailureDialog extends AP.view.Dialog
        heading: heading
        content: message
        hide: hide
      dialog = new FailureDialog
      dialog.show()
  onSaveSuccess: (instance) ->
    message = @success_message
    hide = =>
      if @success_action == 'Back'
        if (@owner or @parent).hasBack()
          (@owner or @parent).back()
        else
          (@owner or @parent).show({reverse: true})
      else if @success_action == 'Open Page'
        successPage = @getSuccessPage()
        successPage.showBackButton = true
        successPage.show()
        successPage.previousPage = (@owner or @parent).previousPage
    if message
      class SuccessDialog extends AP.view.Dialog
        heading: 'Success'
        content: message
        hide: hide
      (new SuccessDialog).show()
    else if @success_action == 'Back'
      (@owner or @parent).back()
    else if @success_action == 'Open Page'
      successPage = @getSuccessPage()
      successPage.showBackButton = true
      successPage.show()
      successPage.previousPage = (@owner or @parent).previousPage
    # rerender form
    @unrender()
    @renderOnce()
    $(@el).trigger('create')
  save: ->
    # TODO temporarily disable form saving on submit until record is saved.
    # if invalid:  enable form saving (subject to validation); if valid:
    # form saving should remain disabled.
    # TODO if save is successful, more saves shouldn't be allowed.
    instance = @getModelInstance()
    if !instance.isValid()
      @onSaveFail instance
      return false
    instance.save null,
      success: => @onSaveSuccess instance
      error: => @onSaveFail instance
