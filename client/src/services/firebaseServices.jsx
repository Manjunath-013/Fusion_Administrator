import { db } from "../firebaseConfig"; 

export const saveUserData = async (uid, email, username) => {
  // If Firebase is not configured, skip saving to Firestore
  if (!db) {
    console.log("Firebase not configured - skipping Firestore save");
    return;
  }

  try {
    const { doc, setDoc } = await import("firebase/firestore");
    await setDoc(doc(db, "users", uid), {
      email,
      username,
      lastLogin: new Date().toISOString(),
    });
    console.log("User data saved successfully");
  } catch (error) {
    console.error("Error saving user data:", error.message);
  }
};
