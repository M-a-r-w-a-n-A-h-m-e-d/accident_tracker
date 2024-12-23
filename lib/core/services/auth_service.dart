import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential?> signInWithGoogle() async {
    print('Starting Google Sign-In...');

    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: ['email', 'profile']);

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('Sign-in was canceled by the user.');
        return null; // User canceled the sign-in
      }

      // Fetch the authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase authentication
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print('User Signed In: ${userCredential.user?.providerData}');

      return userCredential;
    } catch (error) {
      // Catch any errors and print them
      print('Error during Google Sign-In: $error');
      return null;
    }
  }



  static Future<void> signInWithFacebook() async {
    
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success && result.accessToken != null) {
      final credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      log('User: ${result.accessToken!.tokenString}');
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        log('User signed in: ${userCredential.user?.uid}');
      } on FirebaseAuthException catch (e) {
        log('Error signing in with Facebook: ${e.message}');
      }
    } else {
      log('Facebook login failed: ${result.message}');
    }
  }
}
