importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.0/firebase-firestore.js"
);

var firebaseConfig = {
  apiKey: "AIzaSyCMyF3-bCiBJThG7ECpwsbIMynRKfU6blo",
  authDomain: "cosbiome-bcdf4.firebaseapp.com",
  databaseURL: "https://cosbiome-bcdf4.firebaseio.com",
  projectId: "cosbiome-bcdf4",
  storageBucket: "cosbiome-bcdf4.appspot.com",
  messagingSenderId: "270342511775",
  appId: "1:270342511775:web:8ae7476b516b2fdcc5d6aa",
  measurementId: "G-53MCMM5EMW",
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
