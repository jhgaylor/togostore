Meteor.methods
  'promote': (password) ->
    unless password is "apple"
      return

    # TODO: promote @user_id to an admin using roles
