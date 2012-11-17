class AP.view.Label extends AP.view.Component
  className: 'ap-label'
  tag: 'p'
  # Renders a new element on every call, since label is used as a
  # configuration component (even though it's placed into "children" on
  # list items).
  renderString: (context) ->
    context ?= @parent.instance or {}
    rendered = @renderTextFromRecord(@content or '', context)
    if @hyperlink_content == 'true'
      # phone number hyperlinks
      rendered = rendered.replace /^\+?[\d]?[\s\.-]?\(?[\d]{3}\)?[\s\.-]?[\d]{3}[\s\.-]?[\d]{4}$/, '<a href="tel:$&">$&</a>'
      # email regex: http://www.regular-expressions.info/email.html
      rendered = rendered.replace /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, '<a href="mailto:$&">$&</a>'
      # url regex:
      rendered = rendered.replace /^((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))$/i, '<a href="$&">$&</a>'
    "<#{@tag} class=\"#{@className} #{@constructor.viewName.toLowerCase()}\">#{rendered}</#{@tag}>"
  # Hard-render to element.
  render: ->
    @replace @renderString()
    super
