class AP.view.StyledText extends AP.view.Component
  className: 'ap-styled-text'
  render: ->
    content = @content
    if @parent
      content = @parent.renderTextFromInstance(@content)
    @append $(content)
    super
