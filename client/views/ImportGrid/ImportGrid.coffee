Template.ImportGrid.helpers
  grids: ->
    user = Meteor.user()
    unless user
      return
    return GridUploads.find
      _id:
        $in: user.profile.grid_upload_ids
