class AP.view.MapPage extends AP.view.BasePage
  @getCurrentLocation: (successCallback, failureCallback) ->
    if @coords
      successCallback(@coords) if $.isFunction successCallback
    if !@coords and navigator.geolocation
      navigator.geolocation.getCurrentPosition ((location) =>
        @coords = location.coords
        successCallback(@coords) if $.isFunction successCallback
      ), (() =>
        failureCallback() if $.isFunction failureCallback
      )
  className: 'ap-map-page'
  getQueryScope: ->
    @collection ?= new (@getApp().getCollection(@datasource_id or @object_definition_id))
    @collection
  constructor: ->
    super
    @getQueryScope().bind 'reset', () => @dataRefreshed()
  show: ->
    super
    #if @map
    #  google.maps.event.trigger(@map, 'resize')
    #  @map.setCenter @center if @map and @map.setCenter
    #  @map.setZoom @getMapOptions().zoom if @map and @map.setZoom
  render: ->
    super
    if @allow_pagination == 'true'
      @moreButton = $('<a href="#" target="_blank" data-role="button">Load More</a>').click (e) =>
        e.preventDefault()
        e.stopImmediatePropagation()
        @loadMore()
      $('[data-role="body"]', @el).append(@moreButton)
    @mapEl = $('<div class="ap-map" />')
    $('[data-role="body"]', @el).append(@mapEl)
    setTimeout(@proxy(@renderMap), 250)
  update: ->
    @getQueryScope().page 1,
      success: => @hideNoDataMessage()
      error: => @showNoDataMessage()
  loadMore: ->
    @getQueryScope().nextPage()
  getMapOptions: (options) ->
    $.extend {
      zoom: parseInt @zoom, 10
      center: if @center then @center else new google.maps.LatLng(40.557081, -73.928128)
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }, options
  renderMap: ->
    @map = new google.maps.Map @mapEl[0], @getMapOptions()
    @mapRender()
    if @use_current_location == 'true'
      AP.view.MapPage.getCurrentLocation ((coords) =>
        @center = new google.maps.LatLng coords.latitude, coords.longitude
        @map.setCenter @center if @map and @map.setCenter
        @map.setZoom @getMapOptions().zoom if @map and @map.setZoom
      )
  mapRender: ->
    @dataRefreshed()
  dataRefreshed: ->
    if @map
      @clearAllMarkers()
      @addMarkersForAllRecords()
  clearAllMarkers: ->
    if @markers?
      marker.setMap null for marker in @markers
    @markers = []
  addMarkersForAllRecords: ->
    @markerBounds = new google.maps.LatLngBounds()
    @getQueryScope().each (data) => @addMarkerForRecord data
    if (!@center or @use_current_location != 'true') and $(@el).is(':visible')
      @fitToMarkerBounds()
  addMarkerForRecord: (record) ->
    marker = new google.maps.Marker
      map: @map
      title: record.get @title_field
      record: record
    lat = record.get @latitude_field
    lng = record.get @longitude_field
    if lat and lng
      # record has lat/lng data
      marker.setPosition new google.maps.LatLng lat, lng
      @extendMarkerBounds marker.position
      @addMarker marker
  addMarker: (marker) ->
    # push marker to list
    @markers.push marker
    google.maps.event.addListener marker, 'mousedown', () =>
      @itemSelected marker.record
  extendMarkerBounds: (latLng) ->
    @markerBounds.extend latLng
  fitToMarkerBounds: ->
    @map.setCenter @markerBounds.getCenter()
    @map.fitBounds @markerBounds
  getTargetPage: ->
    for name, view of @configuration
      target = view if view.id == @page_id
    target
  itemSelected: (record) ->
    targetPage = @getTargetPage()
    if targetPage and AP.auth.Authorization.isAuthorized(targetPage.constructor.authRules)
      targetPage.showBackButton = true
      targetPage.instance = record
      targetPage.unrender()
      targetPage.show()
    else
      _this = @
      class Dialog extends AP.view.Dialog
        heading: _this.renderTextFromRecord _this.detail_title, record
        content: _this.renderTextFromRecord _this.detail_description, record
      mapDialog = new Dialog
      mapDialog.show()
    false
