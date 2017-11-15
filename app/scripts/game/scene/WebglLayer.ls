require! {
  'game/scene/Layer'
}

const draw-viewport = false

module.exports = class WebglLayer extends Layer
  tag-name: \canvas
  initialize: (options) ->
    super options
    @_resolution = Math.round window.device-pixel-ratio or 1
    @_viewport-width = 300
    @_viewport-height = 300
    @_stage = new PIXI.Container!
    @stage = new PIXI.Container!
    @_stage.add-child @stage
    @_layers = [new PIXI.Container! for i to 6]
    for layer in @_layers => @stage.add-child layer
    @_needs-viewport = []
    # Renderer = if options.canvas
    #   PIXI.CanvasRenderer
    # else
    #   PIXI.WebGLRenderer
    Renderer = PIXI.CanvasRenderer

    @renderer = new Renderer @_viewport-width, @_viewport-height, {
      view: @el
      transparent: true
      resolution: @_resolution
    }

    if draw-viewport
      @dbg = new PIXI.Graphics!
      @add @dbg, 6

  add: (object, at = 3, needs-viewport = false) ->
    super object, x: 0, y: 0
    @_layers[at].add-child object
    if needs-viewport then @_needs-viewport[*] = object

  render: (zoom = 1) ->
    for obj in @_needs-viewport => obj.set-viewport @left, @top, @right, @bottom
    @renderer.render @_stage

  set-viewport: (x, y, width, height, zoom = 1) ->
    if @_viewport-width isnt width or @_viewport-height isnt height
      @_update-viewport-size width, height

    x = zoom * x + (zoom - 1) * width / 2
    y = zoom * y + (zoom - 1) * height / 2
    width = width / zoom
    height = height / zoom

    @stage.position <<< x: -x, y: -y
    @stage.scale.x = @stage.scale.y = zoom
    x = x / zoom
    y = y / zoom
    @ <<< left: x, top: y, right: x + width, bottom: y + height

    if draw-viewport
      @dbg
        ..clear!
        ..line-style 3, 0x00FFFF
        ..draw-rect x, y, width, height

    @render!

  _update-viewport-size: (width, height) ->
    @_viewport-width = width
    @_viewport-height = height
    @renderer.resize width, height
    @renderer.view.style <<< {width: "#{width}px", height: "#{height}px"}
    @stage.filter-area = new PIXI.Rectangle 0, 0, width, height
