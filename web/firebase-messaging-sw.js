// Import and configure the Firebase SDK
// These scripts are made available when the app is served or deployed on Firebase Hosting
// If you do not serve/host your project using Firebase Hosting see https://firebase.google.com/docs/web/setup
importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
    apiKey: "AIzaSyD8OtTSNqQplHUYUOl9RKvxdANsfUzgQnM",
    authDomain: "budget-ss.firebaseapp.com",
    projectId: "budget-ss",
    storageBucket: "budget-ss.appspot.com",
    messagingSenderId: "79455569094",
    appId: "1:79455569094:web:104b3ee25b8b69dd8643c7",
    measurementId: "G-C80CXNE73H"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function (payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);

    // Customize notification here
    const notificationTitle = payload.notification?.title || 'BudgetSS';
    const notificationOptions = {
        body: payload.notification?.body || 'You have a new notification',
        icon: '/favicon.png',
        badge: '/favicon.png',
        tag: 'budget-ss-notification',
        requireInteraction: false,
        actions: []
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener('notificationclick', function (event) {
    console.log('[firebase-messaging-sw.js] Notification clicked', event);

    event.notification.close();

    // Handle the click action
    event.waitUntil(
        clients.matchAll({
            type: 'window',
            includeUncontrolled: true
        }).then(function (clientList) {
            // If there's already a window/tab open, focus it
            for (var i = 0; i < clientList.length; i++) {
                var client = clientList[i];
                if (client.url.includes(self.location.origin) && 'focus' in client) {
                    return client.focus();
                }
            }

            // If no window/tab is open, open a new one
            if (clients.openWindow) {
                return clients.openWindow('/');
            }
        })
    );
});
