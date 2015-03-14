# TODO: publish the SBCs and the user who uploaded it

# this is a temp pub
Meteor.publish "GridUploads", ->
  return GridUploads.find()
