class AP.view.PageButton extends AP.view.BaseButton
  className: 'ap-page-button'
  getTargetPage: ->
    for name, view of @configuration
      target = view if view.id == @page_id
    target
  click: (e) ->
    e.preventDefault()
    targetPage = @getTargetPage()
    if targetPage
      targetPage.showBackButton = true
      targetPage.unrender()
      targetPage.show()
