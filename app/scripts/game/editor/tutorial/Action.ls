require! {
  'game/editor/utils'
  'game/hints/HintController'
}

module.exports = class Action
  (@parent-start, @parent-end, $action) ->
    @$action = $action
    if $action.attr 'at'
      @at = parse-float that
      if is-NaN @at then throw new Error 'Cannot parse action.at'
    else @at = 0

    @start = @parent-start + @at

    if $action.attr 'duration'
      @duration = parse-float that
      if is-NaN @duration then throw new Error 'Cannot parse action.duration'
    else @duration = @parent-end - @start

    @end = @start + @duration

    if $action.attr 'type'
      @type = camelize that
      unless actions[@type]? then throw new Error "No such action.type: #{@type}"
    else throw new Error 'You must specify action.type!'

  set-view: (view, editor) ~>
    @view = view
    @editor = editor
    actions[@type].setup.call this, @$action

  on-start: ~>
    actions[@type].start.call this

  on-end: ~>
    actions[@type].end.call this

get-pos = (pos, range) ->
  | range in <[outer inner]> => {start: pos.start[range], end: pos.end[range]}
  | range is 'open' => {start: pos.start.outer, end: pos.start.inner}
  | range is 'close' => {start: pos.end.inner, end: pos.end.outer}
  | otherwise => throw new Error "Range must be outer, inner, open or close, nor #range"

actions = {
  highlight-code:
    setup: ($el) ->
      @selector = $el.attr 'selector'
      @range = $el.attr 'range' or 'outer'

    start: ->
      if @selector?
        @markers = for el in @editor.render-el.find @selector when el.parse-info
          pos = utils.get-positions el.parse-info, @editor.cm
          console.log 'before' pos
          pos = get-pos pos, @range
          console.log 'after' pos
          @editor.cm.mark-text pos.start, pos.end, class-name: 'highlight-action'

    end: ->
      for marker in @markers when marker? => marker.clear!

  highlight-level:
    setup: ($el) ->
      @selector = $el.attr 'selector'

    start: ->
      if @selector
        @highlights = for el in @editor.render-el.find @selector
          $el = $ el
          $parent = $el.offset-parent!
          rect = el.get-bounding-client-rect!
          parent-rect = $parent.get 0 .get-bounding-client-rect!


          $ '<div></div>'
            ..add-class 'action-highlight'
            ..css {
              top: rect.top - parent-rect.top
              left: rect.left - parent-rect.left
              width: $el.outer-width!
              height: $el.outer-height!
            }
            ..append-to $parent

    end: ->
      for highlight in @highlights
        console.log 'remove' highlight
        highlight.remove!

  highlight-code-and-level:
    setup: ($el) ->
      actions.highlight-code.setup.call this, $el
      actions.highlight-level.setup.call this, $el

    start: ->
      actions.highlight-code.start.call this
      actions.highlight-level.start.call this

    end: ->
      actions.highlight-code.end.call this
      actions.highlight-level.end.call this

  hint:
    setup: ($el) -> @$el = $el

    start: ->
      @hc = new HintController hints: @$el

    end: -> # no-op

  egg:
    setup: ($el) ->
      @dimensions = {
        top: $el.attr 'top' or void
        bottom: $el.attr 'bottom' or void
        left: $el.attr 'left' or void
        right: $el.attr 'right' or void
      }

      @enter = $el.attr 'enter' or 'fade'
      @exit = $el.attr 'exit' or 'fade'
      @egg-type = $el.attr 'egg' or 'normal'
      @egg-src = {
        normal: '/content/common/oracle.png'
        glow: '/content/common/oracle-glow.png'
      }[@egg-type]

    start: ->
      @el = $ '<img>'
        ..add-class "enter-#{@enter} egg-helper egg-#{@egg-type}"
        ..attr 'src' @egg-src
        ..css @dimensions
        ..append-to document.body

    end: ->
      @el.remove!

  egg-content:
    setup: ($el) ->
      @side = $el.attr 'side'
      @other-side = {right: 'left', left: 'right'}[@side]
      @egg = @view.$ '.content-container > .egg'

    start: ->
      @egg
        ..remove-class "show-#{@other-side}"
        ..add-class "show-#{@side}"

    end: ->
      @egg.remove-class "show-#{@side}"
}

