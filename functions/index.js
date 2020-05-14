const functions = require('firebase-functions');
const admin = require('firebase-admin');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp();

exports.onMessage = functions.firestore
    .document('chats/{message}')
    .onCreate((snapshot, ctx) => {
        // console.log(snapshot.data());

        return admin.messaging().sendToTopic('chat', {
            notification: {
                title: snapshot.data().sender,
                body: snapshot.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            }
        });
    });