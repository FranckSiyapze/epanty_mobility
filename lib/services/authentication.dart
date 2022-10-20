import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';


class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

AppUser? _userFromFirebaseUser(User? user) {
  //initUser(user);
  return user != null ? AppUser(uid: user.uid) : null;
}

 // void initUser(User? user) async {
  //  if (user == null) return;
 
 // }


Stream<AppUser?> get user{
  return _auth.authStateChanges().map(_userFromFirebaseUser);
}

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      print("********************************************");
      print('Email : $email \n mot de passe : $password');
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      print(result.user!.uid);
      if (user != null)
        {
          await FirebaseFirestore.instance.collection("Payment").doc(result.user!.uid).set({
            "user": result.user!.uid,
            "trips": 10,
          });
          user.updateDisplayName(name);
          print('*************************success**********************');
        }
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
}

