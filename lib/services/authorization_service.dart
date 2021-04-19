import 'package:crypto_app/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthorizationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String activeUserId;

  Users userAdd(User user) {
    return user == null ? null : Users.firebasedenUret(user);
  }

  Stream<Users> get statusTracker {
    return firebaseAuth.authStateChanges().map(userAdd);
  }

//mail ile kayıt işlemleri
  Future<Users> mailSignUp(String mail, String password) async {
    var loginCard = await firebaseAuth.createUserWithEmailAndPassword(
        email: mail, password: password);
    return userAdd(loginCard.user);
  }

  //mail ile giriş işlemleri
  Future<Users> mailLogin(String mail, String password) async {
    var loginCard = await firebaseAuth.signInWithEmailAndPassword(
        email: mail, password: password);
    return userAdd(loginCard.user);
  }

//çıkış yap metodu
  Future<void> logOut() {
    return firebaseAuth.signOut();
  }

  Future<void> resetPassword(String eposta) async {
    await firebaseAuth.sendPasswordResetEmail(email: eposta);
  }

  //google ile giriş
  Future<Users> googleLogin() async {
    GoogleSignInAccount googleAccount = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuthority =
        await googleAccount.authentication;
    AuthCredential sifresizGirisBelgesi = GoogleAuthProvider.credential(
        idToken: googleAuthority.idToken,
        accessToken: googleAuthority.accessToken);
    UserCredential loginCard =
        await firebaseAuth.signInWithCredential(sifresizGirisBelgesi);
    return userAdd(loginCard.user);
  }
}
