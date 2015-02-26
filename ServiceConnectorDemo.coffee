if Meteor.isClient
  Meteor.startup ->
    console.log 'Configured social login permissions'
    Accounts.ui.config
      requestPermissions:
        facebook: ['read_stream']

  UI.body.events
    'click #sign-out-button': ->
      Meteor.logout()

  Template.linkAccount.events
    'click button': ->
      console.log "Connecting #{this.service} account"
      signInFunc = 'signInWith' + @service.substr(0,1).toUpperCase() + @service.substr(1)
      Meteor[signInFunc] {}, (error, mergedUserId) ->
        if mergedUserId
          console.log mergedUserId, 'merged with', Meteor.userId()
        else
          console.log error

  Template.linkAccount.helpers
    notLinkedWith: ->
      console.log 'checking if merged with ' + @service
      not Meteor.user().services[@service]?

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

  Template.asanaReader.events
    'click button': ->
      console.log 'Reading Asana tasks...'
      Meteor.call 'readAsana', (err, res) ->
        console.log 'Done reading Asana tasks!'
        console.log err
        console.log res
        Session.set 'asanaWorkspaces', res.data

   Template.asanaReader.helpers
     asanaWorkspaces: ->
       Session.get 'asanaWorkspaces'

if Meteor.isServer
  AccountsMerge.onMerge = (winner, loser) ->
    console.log "Merging accounts ", winner, loser
    Meteor.users.remove(loser._id)
