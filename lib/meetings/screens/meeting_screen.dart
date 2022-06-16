import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen(
      {Key? key, required this.appointmentDetails, required this.user})
      : super(key: key);
  final Appointment appointmentDetails;
  final User user;

  @override
  MeetingScreenState createState() => MeetingScreenState();
}

class MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    String meetingName = widget.appointmentDetails.subject;
    String? meetingNotes = widget.appointmentDetails.notes;

    String meetingDate = DateFormat('MMMM dd, yyyy')
        .format(widget.appointmentDetails.startTime)
        .toString();
    String meetingStartTime = DateFormat('hh:mm a')
        .format(widget.appointmentDetails.startTime)
        .toString();
    String meetingEndTime = DateFormat('hh:mm a')
        .format(widget.appointmentDetails.endTime)
        .toString();

    String meetingTimeDetails = "";
    if (widget.appointmentDetails.isAllDay) {
      meetingTimeDetails = 'All day';
    } else {
      meetingTimeDetails = meetingStartTime + " - " + meetingEndTime;
    }

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
              child: const Text('Start Video Chat'),
              onPressed: () {
                Get.to(() => const VideoChatScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
