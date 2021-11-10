// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.helloWorld = functions.database.ref('notification/status').onUpdate(evt => {
    const payload = {
        notification: {
            title: 'Biztonsági értesítés',
            body: 'A szenzor mozgást érzékelt', 
        }
    };

    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if (allToken.val() && evt.after.val() == 'yes') {
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token, payload);
        } else {
            console.log('No token available');
        }
    });
});