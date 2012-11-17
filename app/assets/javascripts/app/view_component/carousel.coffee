class AP.view.Carousel extends AP.view.Component
  className: 'ap-carousel'
  elements:
    '.ap-carousel-container': 'container'
    '.ap-carousel-indicator': 'indicator'
    '.carousel': 'carousel'
  constructor: ->
    super
    @getQueryScope().bind 'reset', @proxy(@renderItems)
    @bind 'reset', @onRefresh
  onRefresh: ->
    # pass
  getQueryScope: ->
    if !@scope
      scopeCollectionClass = @getApp().getCollection(@datasource_id or @object_definition_id)
      @scope = new (scopeCollectionClass)
      @scope.pageSize = parseInt(@per_page, 10) if @per_page and @allow_pagination
    @scope
  update: ->
    # Normally, we don't want to refresh a carousel every time it's shown.  For
    # carousel with a query, however, we do, since the query may change
    if @queryOn
      @getQueryScope().query @queryOn.toJSON(),
        success: => @hideNoDataMessage()
        error: => @showNoDataMessage()
    else
      @getQueryScope().fetch
        success: => @hideNoDataMessage()
        error: => @showNoDataMessage()
    @trigger 'reset'
  renderItems: ->
    html = $('<div class="ap-carousel-container"><ul class="carousel"></ul><ul class="ap-carousel-indicator"></ul></div>')
    $(@el).empty()
    @append html
    @refreshElements()
    setTimeout (=>
      # carousel script needs a preset width
      #containerWidth = $(@container).width()
      #$(@container).width(containerWidth)
      # add items to carousel
      i = 0
      @getQueryScope().each (data) =>
        item = $(@getItemHtml(data))
        @carousel.append(item)
        $(@el).data "instance-#{i}", data
        i++
        @indicator.append($('<div class="ap-carousel-indicator-item"></div>'))
      # handle carousel click events
      @container.unbind('carouselclick').bind('carouselclick', => @onCarouselClick())
      @refreshElements()
      $(@container).addTouch()
      $(@carousel).carousel(afterStop: @proxy @onAfterStop)
      $('div', @indicator).eq(0).addClass('ap-carousel-indicator-item-active')
      @trigger 'reset'
    ), 500
  onAfterStop: (index) ->
    $('div', @indicator).removeClass('ap-carousel-indicator-item-active')
    $('div', @indicator).eq(index - 1).addClass('ap-carousel-indicator-item-active')
  getItemHtml: (data) ->
    @renderTextFromRecord("<li><div class=\"ap-carousel-item\"><div class=\"ap-carousel-item-image\" style=\"background-image: url(#{data.get(@image_url_field)});\"></div><div class=\"ap-carousel-detail\"><div class=\"ap-carousel-title\">#{@detail_title or ''}</div><div class=\"ap-carousel-description\">#{@detail_description or ''}</div></div></div></li>", data)
  loadMore: ->
    @getQueryScope().nextPage()
  onCarouselClick: () ->
    index = $('> div', @container).data('currentpage') - 1
    record = $(@el).data("instance-#{index}")
    @itemClick record
  getTargetPage: ->
    for name, view of @configuration
      target = view if view.id == @page_id
    target
  itemClick: (record) ->
    targetPage = @getTargetPage()
    if targetPage
      targetPage.showBackButton = true
      targetPage.instance = record
      targetPage.unrender()
      targetPage.show()
    false
