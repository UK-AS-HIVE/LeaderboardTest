if Meteor.isClient
  Meteor.startup ->
    console.log 'Configured social login permissions'
    Accounts.ui.config
      requestPermissions:
        facebook: ['read_stream']

  Template.feedReader.events
    'click button': ->
      console.log 'Reading facebook feed...'
      Meteor.call 'readFacebookPosts', (err, res) ->
        console.log 'Done reading facebook feed!'
        console.log err
        console.log res
        Session.set 'fbfeed', res.data

  Template.feedReader.helpers
    feedItems: -> Session.get 'fbfeed'
