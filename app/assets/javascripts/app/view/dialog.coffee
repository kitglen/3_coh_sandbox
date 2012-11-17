class AP.view.Dialog extends AP.view.Component
  @viewName: 'Dialog'
  @baseName: 'dialog'
  @childComponentNames: []
  @configurationComponentNames: []
  @authRules: []
  template: '''
    <div data-role="page">
      <div data-role="header"><h1>{{ heading }}</h1></div>
      <div data-role="content">
        {{ content }}
        <a href="#" data-role="button">OK</a>
      </div>
    </div>
  '''
  heading: 'Dialog'
  content: '<p>Dialog content goes here.</p>'
  events:
    'click [data-role="button"]': 'ok'
    'click [title="Close"]': 'close'
  show: ->
    @previousPage = AP.view.BasePage.getCurrentPage()
    @renderOnce()
    $.mobile.changePage($(@el))
  hide: ->
    $.mobile.changePage($(@previousPage.el), {reverse: true})
  renderOnce: ->
    if !@rendered
      @render()
      @rendered = true
  render: ->
    @replace(@template.replace('{{ heading }}', @heading).replace('{{ content }}', @content))
    $(@el).appendTo('body').dialog()
  close: (e) ->
    @ok()
  ok: (e) ->
    @hide()
    false
