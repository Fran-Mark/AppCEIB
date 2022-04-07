'use strict';

const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const payload = {
    notification: {
      title: 'Hay un anuncio nuevo',
      body: `Entra a la aplicación para verlo`,
 
    }
  };

exports.sendNewEventNotification = functions.database.ref('/events').onWrite(event => {
    admin.messaging().sendToTopic('events', payload);
});