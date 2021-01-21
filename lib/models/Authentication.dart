import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementaion {
  Future<String> SignIn(String email, String password);
  Future<String> SignUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements AuthImplementaion {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> SignIn(String email, String password) async {
    // ignore: deprecated_member_use
    // FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
    //         email: email, password: password))
    //     .user;
    // return user.uid;
    User user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  Future<String> SignUp(String email, String password) async {
    // ignore: deprecated_member_use
    // FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    // return user.uid;
    User user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    // ignore: deprecated_member_use
    // FirebaseUser user = await _firebaseAuth.currentUser();
    // return user.uid;
    User user = await _firebaseAuth.currentUser;
    return user.uid;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
