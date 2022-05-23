import 'package:alexandrya/auth/helpers/auth_manager.dart';
import 'package:alexandrya/auth/controllers/auth_controller.dart';
import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
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
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Video Chat'),
          onPressed: () {
            Get.to(const VideoChatScreen());
          },
        ),
      ),
    );
  }
}
