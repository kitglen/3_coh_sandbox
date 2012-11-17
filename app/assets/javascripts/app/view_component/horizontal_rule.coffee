class AP.view.HorizontalRule extends AP.view.Component
  className: 'ap-horizontal-rule'
  template: '<hr />'
  render: ->
    @append $(@template)[0]
    super
