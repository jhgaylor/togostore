Router.route '/',
  name: "Index"
  subscriptions: ->
    handles = [
      Meteor.subscribe("GridUploads")
      Meteor.subscribe("TogoPoints")
      ]
    return handles

# TODO: ensure that user is an admin or bounce them
Router.route '/admin',
  name: "AdminIndex"
