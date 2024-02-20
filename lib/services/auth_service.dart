import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  String email = "pronskypablo@gmail.com";

  ///Google Sign In method. not being used yet.
  signInWithGoogle() async {
    // Interact
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Auth_details
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    // User credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Log in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
