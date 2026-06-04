importScripts('https://www.gstatic.com/firebasejs/12.13.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.13.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCqXqMZEAu9bPmgxikZqhsLUP8RIQox5-c',
  authDomain: 'ap1-coach.firebaseapp.com',
  projectId: 'ap1-coach',
  storageBucket: 'ap1-coach.firebasestorage.app',
  messagingSenderId: '699390760154',
  appId: '1:699390760154:web:a2abc389cee33b1b67c1e3',
});

const messaging = firebase.messaging();

const DEFAULT_LINK = 'https://ap1.learningfactory.io';

// Neuen Service Worker sofort aktiv schalten, damit der alte (mit kaputtem/
// fehlendem notificationclick-Handler) nicht haengen bleibt.
self.addEventListener('install', (e) => self.skipWaiting());
self.addEventListener('activate', (e) => e.waitUntil(self.clients.claim()));

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Data-only Messages: Titel/Body kommen jetzt aus payload.data (nicht mehr
  // aus payload.notification), damit nur EINE Notification entsteht.
  const notificationTitle = payload.data?.title || 'AP1 Coach';
  // Link zum Oeffnen beim Klick: bevorzugt data.link, sonst fcmOptions.link.
  const link = payload.data?.link || payload.fcmOptions?.link || DEFAULT_LINK;
  const notificationOptions = {
    body: payload.data?.body || 'Deine tägliche Challenge wartet.',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-maskable-192.png',
    // tag + renotify: false -> ein erneuter Daily-Push ersetzt eine noch
    // offene Benachrichtigung still, statt eine zweite zu stapeln.
    tag: 'daily-challenge',
    renotify: false,
    // Link fuer den notificationclick-Handler mitgeben.
    data: { ...(payload.data || {}), link },
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Klick auf die Benachrichtigung: schliessen, bestehendes Fenster fokussieren
// (sonst neues oeffnen). Ohne diesen Handler bleibt die Notification auf
// Android haengen und laesst sich nicht oeffnen.
self.addEventListener('notificationclick', function(event) {
  event.notification.close();
  const link = event.notification.data?.link || DEFAULT_LINK;

  event.waitUntil(
    clients
      .matchAll({ type: 'window', includeUncontrolled: true })
      .then(function(windowClients) {
        for (const client of windowClients) {
          // Bereits offenes App-Fenster fokussieren.
          if (client.url.startsWith(DEFAULT_LINK) && 'focus' in client) {
            if ('navigate' in client) {
              try {
                client.navigate(link);
              } catch (e) {
                // navigate kann je nach Browser fehlschlagen — Fokus reicht.
              }
            }
            return client.focus();
          }
        }
        // Kein passendes Fenster offen -> neues oeffnen.
        if (clients.openWindow) {
          return clients.openWindow(link);
        }
      })
  );
});
