Meteor.startup(function() {
  Meteor.methods({

    /*'postToFacebook': function(text) {
      if (Meteor.user().services.facebook.accessToken) {
        var graph = Npm.require('fbgraph');
        graph.setAccessToken(Meteor.user().services.facebook.accessToken);
        var future = new Future();
        var onComplete = future.resolver();
        graph.post('/me/feed', {message:text}, function(err,result) {
          return onComplete(err,result);
        });
        Future.wait(future);
      }
      else {
        return false;
      }
    },*/
    'readFacebookPosts': function() {
      console.log('READING FACEBOOK POSTS');
      if (Meteor.user().services.facebook.accessToken) {
        var fb = Meteor.require('fbgraph');
        var Future = Meteor.require('fibers/future');
        fb.setAccessToken(Meteor.user().services.facebook.accessToken);
        var future = new Future();
        var resolver = future.resolver();
        fb.get('/me/feed', function(err,res) {
          console.log(res);
          return resolver(err,res);
        });
        Future.wait(future);
        return future.get();
      } else {
        return false;
      }
    }
  });
});

