import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
import 'package:alexandrya/events/models/event_model.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, required this.eventDetails, required this.user})
      : super(key: key);
  final EventModel eventDetails;
  final User user;

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    String eventName = widget.eventDetails.eventName;

    String eventDate =
        DateFormat('MMMM dd, yyyy').format(widget.eventDetails.from).toString();
    String eventStartTime =
        DateFormat('hh:mm a').format(widget.eventDetails.from).toString();
    String eventEndTime =
        DateFormat('hh:mm a').format(widget.eventDetails.to).toString();

    String eventTimeDetails = "";
    if (widget.eventDetails.isAllDay) {
      eventTimeDetails = 'All day';
    } else {
      eventTimeDetails = eventStartTime + " - " + eventEndTime;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.firstname + " " + widget.user.lastname),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(eventName,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            Text(eventDate, style: const TextStyle(fontSize: 15)),
            Text(eventTimeDetails, style: const TextStyle(fontSize: 15)),
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
