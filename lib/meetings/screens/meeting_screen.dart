import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
import 'package:alexandrya/helpers/loading/loading_overlay.dart';
import 'package:alexandrya/auth/helpers/auth_manager.dart';
import 'package:alexandrya/meetings/models/meeting.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  bool showProgress = false;
  //
  @override
  Widget build(BuildContext context) {
    //
    String meetingName = widget.meetingDetails.subject;
    String? meetingNotes = widget.meetingDetails.notes;

    AuthManager _authManager = Get.find();
    String? userLogged = _authManager.getUserToken();

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
              Positioned(
                  top: 120,
                  left: 10,
                  child: ElevatedButton(
                    child: Text(format.currencySymbol +
                        " " +
                        widget.meetingDetails.price.toString()),
                    onPressed: () {
                      insertMeetingsByAttendant();
                    },
                  )),
              Positioned(
                top: 120,
                left: 90,
                child: ElevatedButton(
                  child: const Text('Start Video Chat'),
                  onPressed: () {
                    Get.to(() => const VideoChatScreen());
                  },
                ),
              ),
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

  void insertMeetingsByAttendant() async {
    setState(() {
      showProgress = true;
    });
    //
    await Future.delayed(const Duration(seconds: 0));
    String sStatusMessage = "";
    //
    final url = Uri.parse(
        'https://us-east1-bamboo-dryad-351723.cloudfunctions.net/insmeetingsbyattendant?meetingid=257&hostid=1&attendantuid=kiPmBwRY6wVIqSLBmxbjHxRbAex1');
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
    //
    setState(() {
      showProgress = false;
    });
  }
}
