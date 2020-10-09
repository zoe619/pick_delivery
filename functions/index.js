const functions = require('firebase-functions');
const admin  = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


exports.sendNotification = functions.firestore.document('notifications/{muid}').onWrite(async (event)=>
{

   if(event.after.get('userId') !== null)
   {
      console.log(event.after.get('userId'));
   }

    const uid = event.after.get('userId');
    const title = "New Delivery Request";
    const body = "You have a new delivery request";

     var payload = {
      notification : {
               title:title,
               body:body,
               sound : 'default'
            },
         data: {
         click_action: 'FLUTTER_NOTIFICATION_CLICK',
         message: 'You have a new delivery request',
         view: 'new order'
         },
      };
      const options = {
           priority: 'high',
           timeToLive: 60 * 60 * 24
     };


//    let userDoc = await admin.firestore().doc('users/$uid').get();
//    let fcmToken = userDoc.get('fcm');
    var userRef = await admin.firestore().collection('users').doc(uid);

    return userRef.get().then(doc => {
       if (!doc.exists) {
         console.log('No such User document!');
         throw new Error('No such User document!'); //should not occur normally as the notification is a "child" of the user
       }
        else
        {
//         console.log('Document data:', doc.data());

         let fcmToken = doc.data().fcm;

         try{
             const response = admin.messaging().sendToDevice(fcmToken, payload, options);

          }
          catch(err)
          {
             console.log(err);

          }
          return true;
       }
     })
     .catch(err => {
       console.log('Error getting document', err);
       return false;
     });


});