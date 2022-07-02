import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
import 'package:alexandrya/helpers/loading/loading_overlay.dart';
import 'package:alexandrya/auth/helpers/auth_manager.dart';
import 'package:alexandrya/meetings/models/meeting.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid_util.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen(
      {Key? key, required this.meetingDetails, required this.hostUser})
      : super(key: key);
  final Meeting meetingDetails;
  final User hostUser;

  @override
  MeetingScreenState createState() => MeetingScreenState();
}

class MeetingScreenState extends State<MeetingScreen> {
  final AuthManager _authManager = Get.find();
  late String? userUid = _authManager.getUserToken();
  late int meetingId = widget.meetingDetails.id as int;
  late int hostId = widget.hostUser.iId;
  late String channel = widget.meetingDetails.channel;
  //
  bool showProgress = false;
  //String sChannel = "";
  late bool showPriceButton = (channel == "");
  late bool showVideoChatButton = (channel != "");
  //
  @override
  Widget build(BuildContext context) {
    //
    String meetingName = widget.meetingDetails.subject;
    String? meetingNotes = widget.meetingDetails.notes;

    String meetingDate = DateFormat('MMMM dd, yyyy')
        .format(widget.meetingDetails.startTime)
        .toString();
    String meetingStartTime = DateFormat('hh:mm a')
        .format(widget.meetingDetails.startTime)
        .toString();
    String meetingEndTime =
        DateFormat('hh:mm a').format(widget.meetingDetails.endTime).toString();

    String meetingTimeDetails = "";
    if (widget.meetingDetails.isAllDay) {
      meetingTimeDetails = 'All day';
    } else {
      meetingTimeDetails = meetingStartTime + " - " + meetingEndTime;
    }

    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.hostUser.firstname + " " + widget.hostUser.lastname),
        ),
        body: Center(
            child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: <Widget>[
              Positioned(
                top: 10,
                left: 0,
                child: Container(
                  // height: 40,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.orange,
                  child: Center(
                    child: Text(meetingName,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
              Positioned(
                  top: 60,
                  left: 0,
                  child: Container(
                    //height: 30,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.blue,
                    child: Center(
                      child: Text(meetingNotes!,
                          style: const TextStyle(fontSize: 15)),
                    ),
                  )),
              Positioned(
                  top: 80,
                  left: 0,
                  child: Container(
                    //height: 30,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.yellow,
                    child: Center(
                      child: Text(meetingDate,
                          style: const TextStyle(fontSize: 15)),
                    ),
                  )),
              Positioned(
                  top: 100,
                  left: 0,
                  child: Container(
                    //height: 30,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.green,
                    child: Center(
                      child: Text(meetingTimeDetails,
                          style: const TextStyle(fontSize: 15)),
                    ),
                  )),
              showPriceButton
                  ? Positioned(
                      top: 120,
                      left: 10,
                      child: ElevatedButton(
                        child: Text(format.currencySymbol +
                            " " +
                            widget.meetingDetails.price.toString()),
                        onPressed: () async {
                          //
                          setState(() {
                            showProgress = true;
                          });
                          //
                          getChannel();
                          //
                          await insertMeetingsByAttendant();
                          //
                          setState(() {
                            showProgress = false;
                            showPriceButton = false;
                            showVideoChatButton = true;
                          });
                          //
                        },
                      ))
                  : Container(),
              showVideoChatButton
                  ? Positioned(
                      top: 120,
                      left: (showPriceButton ? 90 : 10),
                      child: ElevatedButton(
                        child: const Text('Start Video Chat'),
                        onPressed: () {
                          Get.to(() => const VideoChatScreen());
                        },
                      ),
                    )
                  : Container(),
              showProgress
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : Container()
            ])));
  }

  void getChannel() {
    Uuid uuid = const Uuid();
    // Generate a v1 (time-based) id
    String sNewChannel = uuid.v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'
    sNewChannel = sNewChannel.substring(0, 8);
    print(sNewChannel);

    setState(() {
      channel = sNewChannel;
    });
  }

  Future<void> insertMeetingsByAttendant() async {
    //
    await Future.delayed(const Duration(seconds: 0));
    String sStatusMessage = "";
    //
    final url = Uri.parse(
        'https://us-east1-bamboo-dryad-351723.cloudfunctions.net/insmeetingsbyattendant?meetingid=$meetingId&hostid=$hostId&attendantuid=$userUid&channel=$channel');

    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> responseObject = jsonDecode(response.body);

      if (responseObject["status"] != null) {
        sStatusMessage = responseObject["status"];
        //
        if (sStatusMessage != "") {
          Get.defaultDialog(
              middleText: sStatusMessage,
              textConfirm: 'OK',
              confirmTextColor: Colors.white,
              onConfirm: () {
                Get.back();
              });
        }
      }
    }
  }
}
