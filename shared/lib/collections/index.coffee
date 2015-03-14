TogoCoinSchema = new SimpleSchema
  owner_id:
    type: String
  coins:
    type: Number
    defaultValue: 0


# each document says who owns the coins and how many that person has
@TogoCoinRecords = new Mongo.Collection 'togo_coin_records'

TogoCoinRecords.attachSchema(TogoCoinSchema)

TogoCoinRecords.allow
  insert: ->
    return false
  update: ->
    return false
  remove: ->
    return false


GridUploadStore = new FS.Store.GridFS("grid_uploads")
# the record of the uploaded sbc's and the owner
@GridUploads = new FS.Collection "grid_uploads",
  stores: [GridUploadStore]

# TODO: configure these correctly based on the current user and the doc being accessed
#       don't forget admins
GridUploads.allow
  insert: ->
    return true
  update: ->
    return true
  remove: ->
    return true
  download: ->
    return true


PurchaseSchema = new SimpleSchema
  user_id:
    type: String
  type:
    type: String
  stripeCharge:
    type: Object
    blackbox: true
  amount:
    type: Number
  created:
    type: Date
    autoValue: ->
      if @isInsert
        return new Date()
      else if @isUpsert
        return {$setOnInsert: new Date()}
      else
        @unset()

@Purchases = new Mongo.Collection 'purchases'
Purchases.attachSchema(PurchaseSchema)
