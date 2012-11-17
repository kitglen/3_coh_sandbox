class AP.view.ListPage extends AP.view.BasePage
  className: 'ap-list-page'
  constructor: ->
    super
    _this = @
    baseName = @constructor.baseName
    viewClassName = "#{@constructor.viewName}List"
    # create a list class, instantiate it and copy configuration into it
    class List extends AP.view.List
      @application: _this.constructor.application
      @viewName: viewClassName
      @baseName: "#{baseName}-list"
      @childComponentNames: []
      @configurationComponentNames: _this.constructor.configurationComponentNames
      parent: _this
      filter: true
      datasource_id: _this.datasource_id
      list_item_id: _this.list_item_id
      page_id: _this.page_id
      detail_title: _this.detail_title
      detail_description: _this.detail_description
      image_url_field: _this.image_url_field
      per_page: _this.per_page
      allow_pagination: _this.allow_pagination
    @listChild = new List
    @children[viewClassName] = @listChild
  getQueryScope: -> @listChild.getQueryScope()
  show: ->
    @listChild.queryOn = @instance
    super
