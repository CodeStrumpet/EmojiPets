'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('myApp.services', []).
  value('version', '0.1')

.service( 'DocumentService', [ '$rootScope', function( $rootScope ) {

  var docs = [
      {id: "id1", name: "test1", date: "date1"},
      {id: "id2", name: "test2", date: "date2"},
      {id: "id3", name: "test3", date: "date3"}
    ];

  return {
    documents: function() {
      return docs;
    },
    documentWithId: function(docId) {
      for (var i = 0; i < docs.length; i++) {
        if (docs[i].id === docId) {
          console.log("Document match!!");
          return docs[i];
        }
      }      
    },
    saveDocument: function(doc) {
      var existingDoc = false;

      for (var i = 0; i < docs.length; i++) {
        if (docs[i].id === doc.id) {
          docs[i] = doc;
          existingDoc = true;
        }
      }

      if (!existingDoc) {
        docs.push(doc);
      }


      // TODO write docs back to persistent store
    }
  };
}])

.service('ConstantsService', ['$rootScope', function( $rootScope ) {
    return {
    }
  }]);
