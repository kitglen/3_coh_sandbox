class AP.view.CarouselPage extends AP.view.BasePage
  className: 'ap-carousel-page'
  constructor: ->
    super
    _this = @
    baseName = @constructor.baseName
    viewClassName = "#{@constructor.viewName}CreateForm"
    class Carousel extends AP.view.Carousel
      @application: _this.constructor.application
      @viewName: viewClassName
      @baseName: "#{baseName}-create-form"
      @childComponentNames: []
      @configurationComponentNames: _this.constructor.configurationComponentNames
      filter: true
      datasource_id: _this.datasource_id
      page_id: _this.page_id
      detail_title: _this.detail_title
      detail_description: _this.detail_description
      image_url_field: _this.image_url_field
      per_page: _this.per_page
      allow_pagination: _this.allow_pagination
    @carouselChild = new Carousel
    @addChildComponent @carouselChild
  getQueryScope: ->
    @getApp().getModel(@datasource_id or @object_definition_id)
  show: ->
    @carouselChild.queryOn = @instance
    super
