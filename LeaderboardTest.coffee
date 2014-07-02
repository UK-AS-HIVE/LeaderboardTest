if Meteor.isClient
  Meteor.startup ->
    console.log 'Configured social login permissions'
    Accounts.ui.config
      requestPermissions:
        facebook: ['read_stream']

  UI.body.events
    'click #sign-out-button': ->
      Meteor.logout()

  Template.linkAccounts.events
    'click #connect-account-facebook': ->
      console.log 'Connecting facebook account'
      Meteor.signInWithFacebook {}, (error, mergedUserId) ->
        if mergedUserId
          console.log mergedUserId, 'merged with', Meteor.userId()
        else
          console.log error

  Template.linkAccounts.helpers
    notLinkedWith: (service) ->
      console.log 'checking if merged with ' + service
      not Meteor.user().services[service]?

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

if Meteor.isServer
  AccountsMerge.onMerge = (winner, loser) ->
    Meteor.users.remove()