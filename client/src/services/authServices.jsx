import { auth } from "../firebaseConfig"; 

export const handleLogin = async (email, password) => {
  // If Firebase is not configured, return null and let backend handle authentication
  if (!auth) {
    console.log("Firebase not configured - using backend authentication");
    return null;
  }

  try {
    const { signInWithEmailAndPassword } = await import("firebase/auth");
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;
    console.log("User logged in and data updated");
    return user; 
  } catch (error) {
    console.error("Error during login:", error.message);
    throw error; 
  }
};
