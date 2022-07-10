import 'package:alexandrya/home/screens/home_screen.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:alexandrya/users/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  UsersListScreenState createState() => UsersListScreenState();
}

class UsersListScreenState extends State<UsersListScreen> {
  final controller = ScrollController();
  List<User> items = [];

  bool isLoading = false;
  bool hasMore = true;
  int pageSize = 15;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();

    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;

    final url = Uri.parse(
        'https://us-east1-bamboo-dryad-351723.cloudfunctions.net/getusersbypage?pagesize=$pageSize&pagenumber=$pageNumber');
    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> responseObject = jsonDecode(response.body);
      String sStatus = responseObject["status"];
      List usersList = responseObject["userslist"];

      setState(() {
        pageNumber++;
        isLoading = false;

        if (usersList.length < pageSize) {
          hasMore = false;
        }

        items.addAll(usersList.map<User>((item) {
          User u = User();

          u.iId = item['id'];
          u.firstname = item['firstname'];
          u.lastname = item['lastname'];
          u.email = item['email'];
          u.uid = item['uid'];
          //Images soure
          //https://api.unsplash.com/photos/random?query=woman&client_id=LGttr4Hei-EQUSxEgzev52ajr2S1U1Frr-IRw86gRfE

          if (u.iId.floor().isEven) {
            u.urlavatar =
                'https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1522529599102-193c0d76b5b6';
          } else {
            u.urlavatar =
                'https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1548142813-c348350df52b';
          }

          return u;
        }).toList());
      });
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      pageNumber = 1;

      items.clear();
    });

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
        appBar: AppBar(
          title: const Text('Meet your starts'),
        ),
*/
        appBar: AppBar(
          title: const Text('Meet your starts'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.to(() => const HomeScreen());
              }),
        ),
        body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
                controller: controller,
                // padding: const EdgeInsets.all(8),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(item.urlavatar),
                        ),
                        title: Text(item.firstname + " " + item.lastname),
                        subtitle: Text(item.email),
                        //trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Get.to(() => UserScreen(
                                hostUser: item,
                              ));
                        },
                      ),
                    );
                  } else {
                    return Container(
                        color: Colors.black.withOpacity(0.5),
                        //height: double.infinity,
                        height: (MediaQuery.of(context).size.height),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: hasMore
                            ? const CircularProgressIndicator()
                            : const Text('No more data to load'));

                    /*return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                            child: hasMore
                                ? const CircularProgressIndicator()
                                : const Text('No more data to load')));*/
                  }
                })));
  }
}
