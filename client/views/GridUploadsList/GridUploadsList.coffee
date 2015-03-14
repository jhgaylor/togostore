Template.GridUploadsList.helpers
  gridUploads: ->
    user = Meteor.user()
    grid_upload_ids = user.profile.grid_upload_ids || []
    return GridUploads.find
      _id:
        $in: grid_upload_ids

Template.GridUploadsList.events
  'click .removeUpload': (event, template) ->
    userId = Meteor.userId()
    gridUploadId = @_id
    unless userId
      return
    GridUploads.remove gridUploadId, (err, res) ->
      if err
        console.log "error removing grid upload"
        return
      if res < 1
        console.log "No GridUploads removed"
        return

      # console.log "Successfully removed Grid Upload"
      Meteor.users.update userId,
        $pull:
          'profile.grid_upload_ids': gridUploadId
      , (err, res) ->
        if err
          console.log "error removing grid upload id from user profile"
          return
        if res < 1
          console.log "No profile updated. are you logged in?"
          return
