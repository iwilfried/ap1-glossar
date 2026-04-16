importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCqXqMZEAu9bPmgxikZqhsLUP8RIQox5-c',
  authDomain: 'ap1-coach.firebaseapp.com',
  projectId: 'ap1-coach',
  storageBucket: 'ap1-coach.firebasestorage.app',
  messagingSenderId: '699390760154',
  appId: '1:699390760154:web:a2abc389cee33b1b67c1e3',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification?.title || 'AP1 Coach';
  const notificationOptions = {
    body: payload.notification?.body || 'Deine tägliche Challenge wartet.',
    icon: '/icons/Icon-192.png',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
