// ignore_for_file: avoid_print

import 'dart:async';



import 'package:application5/Helper/helper_function.dart';
import 'package:application5/servicre/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerUserwithEmailandPassword(String username, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if (user != null) {
        await DatabaseService(uid: user.uid).savingUserData(username, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print('Error during user registration: ${e.message}');
      return e.message;
    } catch (e) {
      print('Unexpected error: $e');
      return 'An unexpected error occurred';
    }
  }

  //signout
  Future signOut() async {
    try {
      await HelperFunction.SaveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
