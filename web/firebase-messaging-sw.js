importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyD8OtTSNqQplHUYUOl9RKvxdANsfUzgQnM',
  appId: '1:79455569094:web:104b3ee25b8b69dd8643c7',
  messagingSenderId: '79455569094',
  projectId: 'budget-ss',
  authDomain: 'budget-ss.firebaseapp.com',
  storageBucket: 'budget-ss.appspot.com',
});
const messaging = firebase.messaging();

messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});