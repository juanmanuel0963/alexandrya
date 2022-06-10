import 'package:alexandrya/events/screens/events_list_screen.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({Key? key, required this.user}) : super(key: key);

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.firstname + " " + widget.user.lastname),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.network(
              widget.user.urlavatar,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.user.firstname + " " + widget.user.lastname,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              child: const Text('Availability'),
              onPressed: () {
                Get.to(() => EventsListScreen(user: widget.user));
              },
            ),
          ],
        ),
      ),
    );
  }
}
