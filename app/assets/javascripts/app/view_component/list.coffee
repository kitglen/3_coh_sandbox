class AP.view.List extends AP.view.Component
  className: 'ap-list'
  elements:
    '[data-role="listview"]': 'list'
  constructor: ->
    super
    @getQueryScope().on 'reset', @proxy(@renderListItems)
    @bind 'listRefresh', @listRefresh
  getListItemConfiguration: ->
    for name, view of @configuration
      listItem = view if view instanceof AP.view.ListItem
    if !listItem
      # some lists have no list items so we create them
      list = @
      class ListItem extends AP.view.ListItem
        @viewName: "#{list.viewName}ListItem"
        @baseName: "#{list.baseName}_list_item"
        @childComponentNames: []
        @configurationComponentNames: list.configurationComponentNames or []
        owner: list
      class TitleLabel extends AP.view.Label
        @viewName: "#{list.viewName}TitleLabel"
        @baseName: "#{list.baseName}_title_label"
        @childComponentNames: []
        @configurationComponentNames: []
        hyperlink_content: 'true'
        content: list.detail_title
      class DescriptionLabel extends AP.view.Label
        @viewName: "#{list.viewName}DescriptionLabel"
        @baseName: "#{list.baseName}_description_label"
        @childComponentNames: []
        @configurationComponentNames: []
        hyperlink_content: 'true'
        content: list.detail_description
      listItem = new ListItem
      listItem.addChildComponent(new TitleLabel)
      listItem.addChildComponent(new DescriptionLabel)
    listItem
  getQueryScope: ->
    if !@scope
      scopeCollectionClass = @getApp().getCollection(@datasource_id or @object_definition_id)
      @scope = new (scopeCollectionClass)
      @scope.pageSize = parseInt(@per_page, 10) if @per_page and @allow_pagination
    @scope
  render: ->
    super
    # add jquery mobile list markup
    if !$(@list).size()
      #if @filter then filter = 'data-filter="true"' else ''
      filter = ''
      list = $("<ul data-role=\"listview\" class=\"list-for-#{@list_item_id}\" #{filter} data-inset=\"true\"></ul>")
      @append list
      @refreshElements()
    # add a more button (it will be unhidden on list load, if necessary)
    @moreButton = $('<a href="#" target="_blank" data-role="button">Load More</a>').hide().click (e) =>
      e.preventDefault()
      e.stopImmediatePropagation()
      @loadMore()
    @append @moreButton
  update: ->
    # Normally, we don't want to refresh a list every time it's shown.  For
    # lists with a query, however, we do, since the query may change over time
    #if !@getQueryScope().all().length or @queryOn
    if @queryOn
      @getQueryScope().query @queryOn.toJSON(),
        success: => @hideNoDataMessage()
        error: => @showNoDataMessage()
    else
      @getQueryScope().page 1,
        success: => @hideNoDataMessage()
        error: => @showNoDataMessage()
    @trigger 'listRefresh'
  renderListItems: ->
    collection = @getQueryScope()
    @refreshElements() if @elements
    $(@list).empty()
    listItem = @getListItemConfiguration()
    if !@list.length
      @render()
    collection.each (data) =>
      if listItem
        renderedListItem = listItem.render(data)
        item = $(renderedListItem).click => @itemClick(data)
        item.data 'instance', data
        item.find('img').load @thumbLoad
        @list.append(item)
    @trigger 'listRefresh'
    # Render a "load more" button if pagination is allowed, a more button hasn't
    # yet been added, and the list size is equal to the per_page limit.  A list
    # size less than the limit suggests the total data size is < page size.
    # There is no meta data yet about total data size.
    if (@allow_pagination == 'true') and (parseInt(@per_page, 10) == collection.size()) and @moreButton
      $(@moreButton).show()
  thumbLoad: (e) =>
    'Vertically centers thumbnail image in list item, if necessary.'
    load = () =>
      thumbHeight = $(e.currentTarget).height()
      item = $(e.currentTarget).parent()
      itemHeight = item.height() + parseInt(item.css('padding-top'), 10) + parseInt(item.css('padding-bottom'), 10)
      if (itemHeight - thumbHeight)
        $(e.currentTarget).css 'marginTop', (itemHeight - thumbHeight) / 2
    # timing hackery, unfortunately, because the image doesn't necessarily have
    # a height immediately after loading
    setTimeout load, 150
  listRefresh: ->
    # because jQuery mobile is sometimes difficult to work with programmatically
    # we must do stuff like this
    try
      # first, try refreshing
      $(@list).listview('refresh')
    catch error
      try
        # then try initializing
        $(@list).listview()
      catch error2
        # pass
  loadMore: ->
    @getQueryScope().nextPage()
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
