import 'package:alexandrya/meetings/screens/meetings_list_screen.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScreen extends StatefulWidget {
  final User hostUser;
  const UserScreen({Key? key, required this.hostUser}) : super(key: key);

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hostUser.firstname + " " + widget.hostUser.lastname),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.network(
              widget.hostUser.urlavatar,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.hostUser.firstname + " " + widget.hostUser.lastname,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              child: const Text('Availability'),
              onPressed: () {
                Get.to(() => MeetingsListScreen(hostUser: widget.hostUser));
              },
            ),
          ],
        ),
      ),
    );
  }
}
