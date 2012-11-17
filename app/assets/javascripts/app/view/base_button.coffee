class AP.view.BaseButton extends AP.view.Component
  className: 'ap-button'
  template: '<a href="#" target="_blank" data-role="button">{{ title }}</a>'
  events:
    'click': 'onClick'
  constructor: ->
    super
    @className += " ap-button"
  render: ->
    title = @title
    title = if @parent and @title then @parent.renderTextFromInstance(@title) else (title or '')
    url = @url
    url = @parent.renderTextFromInstance(@url) if @parent and @url
    button = $(@template.replace('{{ title }}', title)) if @template
    $(button).attr('href', url) if @url
    @append button[0]
    super
  onClick: -> @click.apply @, arguments
  click: ->
    # pass
