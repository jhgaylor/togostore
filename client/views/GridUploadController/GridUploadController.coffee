Template.GridUploadController.events
  'change .gridUpload': (event, template) ->
    userId = Meteor.userId()
    # don't do anything for anonymous users
    unless userId
      return
    FS.Utility.eachFile event, (file) ->
      GridUploads.insert file, (err, fileObj) ->
        if err
          # TODO: handle err
          console.log "error uploading file", err
        else

          fileUrl = "/cfs/files/grid_uploads/#{fileObj._id}"
          console.log "file is at #{fileUrl}"
          Meteor.users.update userId,
            $addToSet:
              'profile.grid_upload_ids': fileObj._id
          , (err, res) ->
            if err
              console.log "Error modifying user doc", err
            unless res is 1
              console.log "Failed to modify a user document. Are you logged in?", res
            else
              console.log "Successfully modified a user document"
