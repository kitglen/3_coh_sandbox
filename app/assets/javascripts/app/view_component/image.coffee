class AP.view.Image extends AP.view.Component
  className: 'ap-image'
  template: '<img src="{{ url }}" />'
  render: ->
    base_name = @constructor.baseName
    extension = (@url or '').split('.').reverse()[0]
    url = "/assets/#{base_name}.#{extension}"
    if @image_url_field
      url = if @getInstanceData()[@image_url_field] then @getInstanceData()[@image_url_field] else (@parent or @owner).getInstanceData()[@image_url_field]
    @append $(@template.replace('{{ url }}', url))[0] if url
    super
