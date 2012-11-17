class AP.view.ObjectQueryForm extends AP.view.BaseForm
  className: 'ap-query-object-form'
  getQueryScope: -> @getTargetPage().getQueryScope()
  getModel: -> @getQueryScope().model
  getTargetPage: ->
    for name, view of @configuration
      target = view if view.id == @page_id
    target
  save: ->
    super
    # get a hash of the query {field: value}
    query = @getModelInstance().toJSON()
    # count fields with values
    count = 0
    (count++ if value) for field, value of query
    # do query and change the page if any query fields were counted
    if count
      target = @getTargetPage()
      target.showBackButton = true
      target.instance = @getModelInstance()
      target.show()
      #target.getQueryScope().query(query)
