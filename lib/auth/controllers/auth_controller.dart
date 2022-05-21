import 'package:firebase_auth/firebase_auth.dart';
import 'package:alexandrya/auth/constants/firebase_constants.dart';
import 'package:alexandrya/auth/helpers/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class AuthController extends GetxController {
  static AuthController authInstance = Get.find();
  late Rx<User?> firebaseUser;
  late final AuthManager authManager;

  @override
  void onInit() {
    super.onInit();
    authManager = Get.find();
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    //ever(firebaseUser, _setInitialScreen);
  }

/*
  _setInitialScreen(User? user) {
    if (user != null) {
      // user is logged in
      Get.offAll(() => const HomeScreen());
    } else {
      // user is null as in user is not available or not logged in
      Get.offAll(() => const LoginView());
    }
  }
*/
  Future<String> login(String email, String password) async {
    //Status message
    String sStatusMessage = "";
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((firebaseUser) {
        if (firebaseUser.user != null) {
          //Set isLogin to true
          authManager.login(firebaseUser.user?.uid);
          //Set return message
          sStatusMessage = "OK";
        }
      });
    } on FirebaseAuthException catch (e) {
      //Set return message
      sStatusMessage = e.code;
      //signOut
      signOut();
      //Print Exception
      debugPrint("App Exception: auth_controller/login : " + sStatusMessage);
    } catch (e) {
      //Set return message
      sStatusMessage = e.toString();
      //signOut
      signOut();
      //Print Exception
      debugPrint("App Exception: auth_controller/login : " + sStatusMessage);
    } finally {}

    return sStatusMessage;
  }

  Future<String> register(String email, String password) async {
    //Status message
    String sStatusMessage = "";
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((firebaseUser) {
        if (firebaseUser.user != null) {
          //Set isLogin to true
          authManager.login(firebaseUser.user?.uid);
          //Set return message
          sStatusMessage = "OK";
        }
      });
    } on FirebaseAuthException catch (e) {
      //Set return message
      sStatusMessage = e.code;
      //Print Exception
      debugPrint("App Exception: auth_controller/login : " + sStatusMessage);
      //signOut
      signOut();
    } catch (e) {
      //Set return message
      sStatusMessage = e.toString();
      //Print Exception
      debugPrint("App Exception: auth_controller/login : " + sStatusMessage);
      //signOut
      signOut();
    } finally {}

    return sStatusMessage;
  }

  void signOut() {
    //Status message
    String sStatusMessage = "";

    try {
      auth.signOut();
      authManager.logOut();
    } catch (e) {
      //Print Exception
      debugPrint("App Exception: auth_controller/signOut : " + sStatusMessage);
    }
  }
}
