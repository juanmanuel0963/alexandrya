import 'package:alexandrya/auth/controllers/auth_controller.dart';
//import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
import 'package:alexandrya/users/screens/users_list_screen.dart';
import 'package:alexandrya/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
              onPressed: () {
                AuthController.authInstance.signOut();
                Get.to(() => const AuthScreen());
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Artists list'),
          onPressed: () {
            Get.to(() => const UsersListScreen());
          },
        ),
      ),
    );
  }
}
