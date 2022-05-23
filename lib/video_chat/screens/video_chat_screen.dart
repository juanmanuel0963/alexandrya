import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoChatScreen extends StatefulWidget {
  const VideoChatScreen({Key? key}) : super(key: key);

  @override
  VideoChatScreenState createState() => VideoChatScreenState();
}

class VideoChatScreenState extends State<VideoChatScreen> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: "b2a08fe59f714c148d732406e3e4f83e",
        channelName: "LiveChannel1",
        tempToken:
            "006b2a08fe59f714c148d732406e3e4f83eIACNwtqjbeFSCbDkt2voKbuKeghPly6tk9UGxopOo4fIz6LaFH8AAAAAEAASigVRxwyNYgEAAQDHDI1i"),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
    agoraEventHandlers: AgoraEventHandlers(
      userJoined: (uid, elapsed) => print("USER JOINED: $uid"),
      userOffline: (uid, reason) => print("USER OFFLINE REASON $reason"),
      leaveChannel: (rtcstats) => print("USER LEAVE CHANNEL REASON $rtcstats"),
      onError: (errorcode) => print("ON ERROR EVENT REASON $errorcode"),
    ),
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
      /*
      appBar: AppBar(
        title: const Text('Second Route'),
      ),*/
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
      /*
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
      */
    );
  }
}
