import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<User> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken);

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = _auth.currentUser;
  assert(user.uid == currentUser.uid);

  updateDatabase(user);
  return user;
}

Future<void> signOutGoogle() async {
  await _auth.signOut();
  await googleSignIn.disconnect();
  await googleSignIn.signOut();
}

void updateDatabase(User user) async {
  await _firestore.collection('users').doc(user.uid).set({
    'id': user.uid,
    'email': user.email,
    'name': user.displayName,
    'photoUrl': user.photoURL
  }, SetOptions(merge: true));
}
