class AP.view.PieChart extends AP.view.BaseChart
  className: 'ap-pie-chart'
  chartType: 'pie'
  getData: ->
    '''
    Pie charts need x/y data combined into a single series.  SuperChart uses the
    "y" data (dependent variable data) for the series.
    '''
    data = super
    data.y = (([data.x[i], data.y[i]]) for i in [0..(data.x.length - 1)])
    data
