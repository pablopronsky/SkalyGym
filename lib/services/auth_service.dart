import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  //Google Sign In
  signInWithGoogle() async{
    // interaccion
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // auth_details del request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // credencial para el usuario
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // logea
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}