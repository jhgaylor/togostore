Checkout = null
numberOfCoins = 0
Template.Index.created = ->
  Checkout = StripeCheckout.configure
    key: 'pk_test_G5wSXxhreaC1MCn1czD53faP'
    image: '/logo1.png'
    # The callback after checkout is complete
    token: (token) ->
      # TODO: how do i get numberOfCoins
      console.log token, numberOfCoins
      Meteor.call 'coins/buy', token, numberOfCoins, (err, res) ->
        if err
          console.log "failed to buy coins", err
        console.log "successfully bought coins", res
        # reset the global numberOfCoins to prevent double purchases
        numberOfCoins = 0


Template.Index.destroyed = ->
  Checkout.close()
Template.Index.helpers
  numberOfCoins: ->
    userId = Meteor.userId()
    unless userId
      return
    coinRecord = TogoCoinRecords.findOne({owner_id: userId})
    numberOfCoins = coinRecord && coinRecord.coins
    return numberOfCoins || 0

Template.Index.events
  'click .buyPoints': ->
    EZModal
      bodyTemplate: "BuyPoints"
      leftButtons: [{
        color: 'danger'
        html: 'Cancel'
      }, {
        color: 'success'
        html: 'Order'
        fn: (e, tmpl) ->
          $coinsRadio = tmpl.$('input[name="points"]:checked')
          numberOfCoins = parseInt($coinsRadio.val())
          userId = Meteor.userId()
          # TODO: make this more advanced
          amount = 1*numberOfCoins # 1 point is $0.01
          Checkout.open
            name: "Prometheus Rising"
            description: "Buy TogoCoins"
            amount: amount
            numberOfCoins: numberOfCoins
      }]

  'click .importGrid': ->
    EZModal
      bodyTemplate: "ImportGrid"
      leftButtons: [{
        color: 'danger'
        html: 'Cancel'
      }, {
        color: 'success'
        html: 'Import'
        fn: (e, tmpl) ->
          $gridsRadio = tmpl.$('input[name="grids"]:checked')
          gridId = $gridsRadio.val()
          userId = Meteor.userId()
          console.log gridId, userId
          Meteor.call 'grid/import', (gridId), (err, res) ->
            console.log "grid/import", err, res
      }]
