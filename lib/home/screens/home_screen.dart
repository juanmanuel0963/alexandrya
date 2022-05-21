import 'package:alexandrya/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //AuthenticationManager _authManager = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
              onPressed: () {
                //_authManager.logOut();
                // this icon button is for the user to signout
                AuthController.authInstance.signOut();
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: const Center(
        child: Text('home'),
      ),
    );
  }
}
