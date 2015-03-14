Stripe = StripeAPI("sk_test_Ama1iFEoxznTWT6iRyavndw7")
# How to record the purchase of togo_coins
Future = Npm.require('fibers/future');
Meteor.methods
  'coins/buy': (stripeToken, numberOfCoins) ->
    # ensure numberOfCoins is an expected value
    unless numberOfCoins is 200 or numberOfCoins is 400 or numberOfCoins is 100
      fut.return false
    if numberOfCoins < 0
      fut.return false

    amount = 1*numberOfCoins
    userId = @userId
    unless userId
      fut.return false

    fut = new Future()
    stripeCallback = Meteor.bindEnvironment (err, stripeCharge) ->
      if err
        console.log "error charging stripe card", err
        fut.return false

      console.log "stripe charge successful", stripeCharge
      # record the purchase
      newPurchaseId = Purchases.insert
        user_id: userId
        type: "coins"
        stripeCharge: stripeCharge
        amount: amount
      console.log "new purchase id #{newPurchaseId}"
      selector =
        owner_id: userId
      updateModifier =
        $inc:
          coins: numberOfCoins
      doc =
        owner_id: userId
        coins: numberOfCoins

      recordExists = TogoCoinRecords.find(selector).count()
      if recordExists > 0
        num = TogoCoinRecords.update(selector, updateModifier)
      else
        num = TogoCoinRecords.insert(doc)
      console.log num
      fut.return !! num

    # TODO: charge stripe or bail
    Stripe.charges.create
      amount: amount,
      currency: "USD",
      source: stripeToken.id
    ,  stripeCallback


    console.log "done"
    return fut.wait()
