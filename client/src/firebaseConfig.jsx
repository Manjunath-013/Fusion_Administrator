import { initializeApp } from "firebase/app";
import { getAuth, initializeAuth, browserLocalPersistence } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const apiKey = import.meta.env.VITE_API_KEY;
const authDomain = import.meta.env.VITE_AUTH_DOMAIN;

// Check if Firebase credentials are properly configured
const isFirebaseConfigured = apiKey && 
    authDomain && 
    apiKey !== 'placeholder_key' && 
    !authDomain.includes('placeholder');

let app = null;
let auth = null;
let db = null;

if (isFirebaseConfigured) {
    const firebaseConfig = {
        apiKey: apiKey,
        authDomain: authDomain,
        projectId: "fusion-system-admin",
        storageBucket: "fusion-system-admin.firebasestorage.app",
        messagingSenderId: "315737830873",
        appId: "1:315737830873:web:060aac2555855892e9d5c8"
    };

    app = initializeApp(firebaseConfig);
    auth = getAuth(app);
    db = getFirestore(app);
    console.log('Firebase initialized successfully');
} else {
    console.log('Firebase not configured - using backend authentication only');
}

export { app, auth, db };