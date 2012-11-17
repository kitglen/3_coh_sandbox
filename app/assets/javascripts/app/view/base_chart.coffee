class AP.view.BaseChart extends AP.view.Component
  className: 'ap-chart'
  template: '<div id="chart-{{view_name}}" class="ap-chart-container"></div>'
  elements:
    '.ap-chart-container': 'chartContainer'
  constructor: ->
    super
    @getQueryScope().bind 'reset', @renderChart
    @bind 'show', @showChart
  getQueryScope: ->
    if !@scope
      scopeCollectionClass = @getApp().getCollection(@datasource_id or @object_definition_id)
      @scope = new (scopeCollectionClass)
      @scope.pageSize = parseInt(@per_page, 10) if @per_page and @allow_pagination
    @scope
  getModel: -> @getQueryScope().model
  render: ->
    super
    chart = @template.replace '{{view_name}}', @constructor.viewName
    chartHeight = $(window).height() - 100
    $(@el).html chart
    @refreshElements()
    $(@chartContainer).height(chartHeight)
    @getQueryScope().fetch
      success: => @hideNoDataMessage()
      error: => @showNoDataMessage()
    @renderChart()
  showChart: =>
    setTimeout((() =>
      if !@shown
        @shown = true
        @renderChart()), 250)
    #else
    #  $(window).trigger('resize')
  renderChart: =>
    if $("#chart-#{@constructor.viewName}").size() and @shown
      options = @getOptions()
      @chart = new Highcharts.Chart options
  getOptions: ->
    data = @getData()
    options =
      chart:
        renderTo: "chart-#{@constructor.viewName}"
        type: @chartType or 'scatter'
        backgroundColor: 'transparent'
      title:
        text: "#{@title or ''}"
      credits:
        enabled: false
      xAxis:
        categories: data.x
        title:
          text: @getIndependentVariableField().name
        labels:
          rotation: -45
          align: 'right'
      yAxis:
        title:
          text: @getDependentVariableField().name
      series: [
        name: @getDependentVariableField().name
        data: data.y
      ]
    options.title.style = @styles.title if @styles and @styles.title
    # Disable "call-out" style labels and show in a regular legend.
    # Call-out labels get clipped because they are not considered when
    # determining chart width.  This is a known issue:
    # https://github.com/highslide-software/highcharts.com/issues/223
    if @chartType == 'pie'
      options.plotOptions =
        pie:
          dataLabels:
            enabled: false
          showInLegend: true
    options
  getFieldById: (fieldId) -> _.find(@getModel()::fieldDefinitions, (field) -> field.id == fieldId)
  getIndependentVariableField: ->
    # decode the field ID
    fieldId = @independent_variable_field_ids[0]
    @getFieldById(fieldId)
  getDependentVariableField: ->
    # decode the field ID
    fieldId = @dependent_variable_field_ids[0]
    @getFieldById(fieldId)
  getData: ->
    'Returns x and y datasets as arrays.'
    data =
      x: []
      y: []
    independentVariableFieldName = @getIndependentVariableField().name
    dependentVariableFieldName = @getDependentVariableField().name
    @getQueryScope().each (item) =>
      data.x.push item.get(independentVariableFieldName)
      data.y.push item.get(dependentVariableFieldName)
    data
