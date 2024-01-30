import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth_module;
import 'package:gide/core/models/user_model.dart';
import 'package:gide/core/services/user_service.dart';

import 'package:google_sign_in/google_sign_in.dart' as google_module;

class AuthenticationService {
  static final _googleSignIn = google_module.GoogleSignIn();
  static final auth = firebase_auth_module.FirebaseAuth.instance;

  static CollectionReference users = FirebaseFirestore.instance.collection('users');

  static User? userInfo;

  static Future<firebase_auth_module.User?> loginWithGoogle() async {
    final google_module.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth_module.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final response = await firebase_auth_module.FirebaseAuth.instance.signInWithCredential(credential);

    if (response.additionalUserInfo!.isNewUser) {
      if (response.user == null) return Future.value(response.user);
      User user = User(
        id: response.user!.uid, 
        username: response.user!.displayName!, 
        storeId: null,
        credits: const [],
        favoriteStores: const [],
        lastModified: Timestamp.now()
      );

      UserService.updateUser(user);
    }

    return Future.value(response.user);
  }

  static Future<firebase_auth_module.User?> loginWithEmailAndPassword(email, password) async {
    final firebase_auth_module.UserCredential? credential = await auth.signInWithEmailAndPassword(email: email, password: password);

    return Future.value(credential?.user);
  }

  static Future<firebase_auth_module.User?> registerWithEmailAndPassword(email, password, username) async {
    final firebase_auth_module.UserCredential? credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

    if (credential!.user == null) return Future.value(credential.user);
    User user = User(
      id: credential.user!.uid, 
      username: username,
      storeId: null,
      credits: const [],
      favoriteStores: const [],
      lastModified: Timestamp.now()
    );
    
    UserService.updateUser(user);

    return Future.value(credential.user);
  }

  static firebase_auth_module.User? getCurrentUser() {
    return firebase_auth_module.FirebaseAuth.instance.currentUser;
  }

  static Future<User> setUserInfo() async {
    var currUser = getCurrentUser()!;

    var snapshot = await users.doc(currUser.uid).get();

    User infoUser = User.fromFirestore(snapshot as DocumentSnapshot<Map<String, dynamic>>, null);

    userInfo = infoUser;

    return infoUser;
  }

  static void removeUserInfo() {
    userInfo = null;
  }

  static Future firebaseLogout() async {
    await firebase_auth_module.FirebaseAuth.instance.signOut();
    
  }
}
