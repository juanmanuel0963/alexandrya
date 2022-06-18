import 'package:alexandrya/meetings/models/meeting.dart';
import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
import 'package:alexandrya/auth/helpers/auth_manager.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen(
      {Key? key, required this.meetingDetails, required this.user})
      : super(key: key);
  final Meeting meetingDetails;
  final User user;

  @override
  MeetingScreenState createState() => MeetingScreenState();
}

class MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
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
        title: Text(widget.user.firstname + " " + widget.user.lastname),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(meetingName,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            Text(meetingNotes!, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 16),
            Text(meetingDate, style: const TextStyle(fontSize: 15)),
            Text(meetingTimeDetails, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(format.currencySymbol +
                  " " +
                  widget.meetingDetails.price.toString()),
              onPressed: () {
                Get.to(() => const VideoChatScreen());
              },
            ),
            ElevatedButton(
              child: const Text('Start Video Chat'),
              onPressed: () {
                Get.to(() => const VideoChatScreen());
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
