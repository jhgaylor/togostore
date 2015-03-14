Meteor.methods
  'grid/import': (grid_upload_id) ->
    grid = GridUploads.findOne(grid_upload_id)
    # TODO: ensure they can afford it, and charge them for it.
    # don't let someone import a ship that isn't theirs
    unless @user_id is grid.owner_id
      return

    Email.send
      from: "jhgaylor@gmail.com",
      to: "stephen.cernota@gmail.com"
      subject: "Import a ship!"
      text: "Someone just imported a ship using the internet."
