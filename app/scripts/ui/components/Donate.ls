require! {
  'hindquarters'
  'lib/stripe'
  'ui/utils/error-panel-list'
  'ui/utils/loader'
}

dom = React.DOM

parse-amount = (str) ->
  parse-float str.replace /[^\d\.]/g, ''

format-amount = (str) ->
  amt = parse-amount str
  if isNaN amt then amt = 1
  "£#{amt .to-fixed 2}"

fmt-amount = (str) ->
  str .= replace /[^\d\.]/g, ''
  "£#str"

module.exports = React.create-class do
  display-name: \Donate

  get-initial-state: ->
    { email: '', amount: '£2.50', errors: [] }

  component-did-mount: ->
    stripe
      .get-handler!
      .then (handler) ~>
        @set-state stripe-handler: handler

  handle-email-change: (e) ->
    @set-state email: e.target.value

  handle-amount-change: (e) ->
    @set-state amount: e.target.value

  handle-amount-blur: ->
    @set-state amount: format-amount @state.amount

  handle-submit: (e) ->
    e.prevent-default!
    errors = []

    email = @state.email.trim!
    amount = 100 * parse-amount @state.amount

    unless email.match /.+@.+/
      errors.push 'Please enter a valid email address so we can send you a free copy of E.A.K.'

    if isNaN amount
      errors.push 'That amount doesn\'t look like a number... :/'

    if amount < 100
      errors.push 'We can only accept donations of £1 or more, sorry :('

    @set-state errors: errors
    if errors.length then return

    @state.stripe-handler.open {
      token: @on-token.bind this, amount, email
      description: 'E.A.K. Donation'
      amount: amount
      email: email
      panel-label: 'Donate {{amount}}'
      billing-address: true
    }

  on-token: (amount, email, token) ->
    @set-state loading: true
    hindquarters.donations
      .donate {
        amount
        email
        token: token.id
        ip: token.client_ip
        card-country: token.card.country
        user-country: token.card.address_country
      }
      .then (donation) ~>
        @set-state loading: false, donated: true
      .catch (e) ~>
        console.log e
        @set-state loading: false, errors: [e.details || 'There was some sort of mysterious drama when we tried to process your donation, so it didn\'t work :(']


  render: ->
    loader.toggle @state.loading || not @state.stripe-handler, 'Loading...',
      dom.div class-name: 'cont clearfix',
        dom.h2 null, 'Donate to E.A.K.'
        dom.h3 null, 'Buy us coffee, get a free copy of the game!'
        dom.form on-submit: @handle-submit,
          error-panel-list 'A wild error message appears!', @state.errors
          if @state.donated
            dom.h3 null, '💜 Thanks for donating 💜'
          else dom.span null, ''
          dom.label class-name: \text-field,
            dom.span null, 'Your email address'
            dom.input {
              type: \text
              ref: \email
              required: true
              placeholder: 'tarquin@glitterquiff.org'
              value: @state.email
              on-change: @handle-email-change
            }
            dom.span class-name: \sub,
              'We won\'t send you spam, or share your email with anyone else :)'
          dom.div class-name: \two-up,
            dom.div class-name: \two-up-col-left,
              dom.label class-name: \text-field,
                dom.span null, 'Amount'
                dom.input {
                  ref: \amount
                  type: \text
                  required: true,
                  value: fmt-amount @state.amount
                  on-change: @handle-amount-change
                  on-blur: @handle-amount-blur
                }
            dom.div class-name: \two-up-col-right,
              dom.button class-name: 'btn donate-submit-btn', type: \submit, 'Donate'