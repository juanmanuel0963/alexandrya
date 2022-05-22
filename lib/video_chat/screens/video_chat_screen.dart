import 'package:alexandrya/auth/controllers/auth_controller.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoChatScreen extends StatefulWidget {
  const VideoChatScreen({Key? key}) : super(key: key);

  @override
  State<VideoChatScreen> createState() => VideoChatScreenState();
}

class VideoChatScreenState extends State<VideoChatScreen> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: "b2a08fe59f714c148d732406e3e4f83e",
        channelName: "LiveChannel1",
        tempToken:
            "006b2a08fe59f714c148d732406e3e4f83eIADmv5g+keChrqsjI5pMpBRfOoBvkW8dUYQMB3DyIi0v66LaFH8AAAAAEACucvvFK8KKYgEAAQAqwopi"),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

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
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
            ),
            AgoraVideoButtons(
              client: client,
            ),
          ],
        ),
      ),
    );
  }
}
