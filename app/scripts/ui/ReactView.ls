module.exports = class ReactView extends Backbone.View
  initialize: ({component, model}) ->
    @component = React.render (React.create-element component, {model}), @el

  args: (...args) ->
    if @component.args then @component.args.apply @component, args
