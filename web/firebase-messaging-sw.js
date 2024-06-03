// firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.6.7/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.7/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in the messagingSenderId.
firebase.initializeApp({
  apiKey: "AIzaSyDhTjozQa6Wn1NzlWErEUCryiNq3Ws1etQ",
  authDomain: "mad-team-project.firebaseapp.com",
  projectId: "mad-team-project",
  storageBucket: "mad-team-project.appspot.com",
  messagingSenderId: "1052926683011",
  appId: "1:1052926683011:ios:e3c62242d824d14c27f8b6"
});

// Retrieve an instance of Firebase Messaging so that it can handle background messages.
const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
