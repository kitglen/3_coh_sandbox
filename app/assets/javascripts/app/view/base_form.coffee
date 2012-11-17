class AP.view.BaseForm extends AP.view.Component
  className: 'ap-form'
  fieldTypes:
    'string': 'text'
    'integer': 'number'
    'date': 'date'
    'float': 'number'
    'boolean': 'toggle'
    'password': 'password'
  template: '<form data-ajax="false" class="ui-corner-all ui-body ui-body-d"></form>'
  fieldTemplate: '''
    <div data-role="fieldcontain">
      <label for="{{ name }}">{{ label }}:</label>
      <input type="{{ type }}" name="{{ name }}" id="{{ name }}" value="{{ value }}" {{ read_only }} {{ required }} />
    </div>
  '''
  imageFieldTemplate: '''
    <div data-role="fieldcontain">
      <label for="{{ name }}">{{ label }}:</label>
      {{ image }}
    </div>
  '''
  toggleFieldTemplate: '''
    <div class="ap-field ap-field-{{ type }}" data-role="fieldcontain">
      <label for="{{ name }}">{{ label }}</label>
      <select name="{{ name }}" id="{{ name }}" data-role="slider" {{ read_only }}>
        <option value="false" {{ selected_off }}>Off</option>
        <option value="true" {{ selected_on }}>On</option>
      </select>
    </div>
  '''
  dateFieldTemplate: '''
    <div data-role="fieldcontain">
      <label for="{{ name }}">{{ label }}:</label>
      <input type="{{ type }}" name="{{ name }}" id="{{ name }}" value="{{ value }}" {{ read_only }} {{ required }} />
    </div>
  '''
  timeFieldTemplate: '''
    <div data-role="fieldcontain">
      <label for="{{ name }}">{{ label }}:</label>
      <input class="ui-input-text ui-body-c ui-corner-all ui-shadow-inset" type="datetime" name="{{ name }}" id="{{ name }}" value="{{ value }}" {{ read_only }} {{ required }} />
    </div>
  '''
  render: ->
    @append($(@template)[0])
    $('form', @el).append(@renderField(field)) for id, field of @getFields()
    $('form', @el).append(@renderSubmit()) if !@readOnly
    $('button', @el).click(@proxy(@submit))
    super
  renderField: (field) ->
    required = if field.required then 'required="required"' else ''
    read_only = if @readOnly then 'disabled="disabled"' else ''
    switch field.type.toLowerCase()
      when "boolean"
        template = @toggleFieldTemplate
      when "date"
        template = @dateFieldTemplate
      when "time"
        template = @timeFieldTemplate
      else
        template = @fieldTemplate
    if field.file_url and (field.file_type == 'Image')
      template = @imageFieldTemplate
    value = if @instance then @instance.get field.name else ''
    value = '' unless value?
    selected_on = if value is true then 'selected="selected"' else ''
    selected_off = if value is false then 'selected="selected"' else ''
    image = if (value and field.file_url and (field.file_type == 'Image')) then "<img class=\"ap-field-image\" src=\"#{value}\" />" else ''
    template
      .replace(/{{ name }}/g, field.name)
      .replace(/{{ type }}/g, @fieldTypes[field.type.toLowerCase()])
      .replace(/{{ label }}/g, field.label)
      .replace(/{{ value }}/g, value)
      .replace(/{{ read_only }}/g, read_only)
      .replace(/{{ required }}/g, required)
      .replace(/{{ image }}/g, image)
      .replace(/{{ selected_on }}/g, (selected_on))
      .replace(/{{ selected_off }}/g, (selected_off))
  renderSubmit: -> '<button>Submit</button>'
  getModel: -> @getApp().getModel(@object_definition_id)
  getValues: ->
    fields = $('form', @el).serializeArray()
    values = {}
    for field in fields
      values[field.name] = field.value
    # attempt to cast booleans, integers, and floats if possible
    for field in @getModel()::fieldDefinitions
      if values[field.name] != undefined
        value = values[field.name]
        switch field.type.toLowerCase()
          when 'boolean'
            values[field.name] = true if ((value == 'true') or (value == '1') or (value == 1))
            values[field.name] = false if ((value == 'false') or (value == '0') or (value == 0))
          when 'integer'
            values[field.name] = parseInt(value, 10) if parseInt(value, 10) == Math.round(parseFloat(value))
          when 'float'
            values[field.name] = parseFloat(value) if $.isNumeric(parseFloat(value))
    values
  getModelInstance: ->
    values = @getValues()
    if @instance
      instance = @instance
    else
      instance = new (@getModel())
      # if this is a new instance, ignore blank values
      for key, value of @getValues()
        delete values[key] if value == ''
    # set values but don't validate yet... we'll check to see if instance is
    # in an invalid state later
    instance.set(values, {silent: true})
    instance
  getFields: ->
    fields = @object_form_field_ids
    model = @getModel()
    collected = []
    if fields
      for field in model::fieldDefinitions
        collected.push(field) if fields.indexOf(field.id) > -1
    else
      collected = model::fieldDefinitions
    collected
  submit: (e) ->
    e.preventDefault()
    @save()
  save: ->
    # pass
