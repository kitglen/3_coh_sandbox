class AP.view.ListItem extends AP.view.Component
  className: 'ap-list-item'
  tag: 'li'
  render: (context) ->
    rendered = ''
    first = true
    for name, child of @children
      if first
        child.tag = 'h3'
        first = false
      (rendered += child.renderString(context)) if (child instanceof AP.view.Label)
    imageUrl = (@owner and context.get(@owner.image_url_field)) or (@parent and context.get(@parent.image_url_field))
    if imageUrl
      rendered = "<img src=\"#{imageUrl}\" />#{rendered}"
    targetPage = @owner.getTargetPage()
    if targetPage && AP.auth.Authorization.isAuthorized(targetPage.constructor.authRules)
      rendered = "<a href=\"#\">#{rendered}</a>"
    "<#{@tag} class=\"#{@className} #{@baseName}\">#{rendered}</#{@tag}>"
