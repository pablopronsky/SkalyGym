import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  String email = "pronskypablo@gmail.com";

  //Google Sign In
  signInWithGoogle() async {
    // interaccion
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // auth_details del request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    // credencial para el usuario
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // logea
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
