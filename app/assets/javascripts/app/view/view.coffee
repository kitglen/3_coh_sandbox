class AP.view.View extends Backbone.View
  @getApp: -> AP.getApp @application
  @toString: -> "Class <#{@name}>"
  getApp: -> @constructor.getApp()
  toString: -> "Instance <#{@constructor.name}>"
  proxy: (fn) -> (=> fn.apply @, arguments)
  append: (html) ->
    'Appends html to the current element.'
    $(@el).append(html)
  replace: (html) ->
    'Replaces the current element with html.'
    el = $(html)
    $(@el).replaceWith(el)
    @setElement el
