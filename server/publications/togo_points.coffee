# TODO: publish the records of which userIds have how many points
Meteor.publish 'TogoPoints', ->
  userId =  @userId
  return TogoCoinRecords.find
    owner_id: userId
