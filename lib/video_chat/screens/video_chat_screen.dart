import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoChatScreen extends StatefulWidget {
  const VideoChatScreen({Key? key}) : super(key: key);

  @override
  VideoChatScreenState createState() => VideoChatScreenState();
}

class VideoChatScreenState extends State<VideoChatScreen> {
  bool isVisible = false;

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: "b2a08fe59f714c148d732406e3e4f83e",
        channelName: "LiveChannel1",
        //username: "user",
        tempToken:
            "006b2a08fe59f714c148d732406e3e4f83eIABN1i6sUrDthU1+l/B/e11bIVnGLXWNKw7l8JepVWKCdKLaFH8AAAAAEAC0lltgDGORYgEAAQAKY5Fi"),
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
    try {
      await client.initialize();
    } catch (exception)
    // ignore: empty_catches
    {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.grid,
            ),
            AgoraVideoButtons(
              client: client,
              enabledButtons: const [
                BuiltInButtons.toggleMic,
                BuiltInButtons.toggleCamera,
                BuiltInButtons.switchCamera,
                BuiltInButtons.callEnd,
              ],
              /*
              extraButtons: [
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isVisible ? Colors.white : Colors.blue),
                    child: isVisible
                        ? const Icon(
                            Icons.visibility,
                            color: Colors.blue,
                            size: 20,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                )
              ],
              */
            ),
            /*
            AgoraVideoButtons(
              client: client,
              enabledButtons: const [
                BuiltInButtons.toggleCamera,
                BuiltInButtons.toggleMic,
                BuiltInButtons.switchCamera,
              ],
              extraButtons: [
                FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end),
                    onPressed: () => _endMeating(context)),
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  _endMeating(BuildContext context) async {
    client.sessionController.endCall();
    Navigator.pop(context);
  }
}
