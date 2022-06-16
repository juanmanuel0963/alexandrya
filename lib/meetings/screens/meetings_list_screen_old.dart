import 'package:alexandrya/meetings/models/meeting_model.dart';
import 'package:alexandrya/meetings/screens/meeting_screen.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class MeetingsListScreenOld extends StatefulWidget {
  const MeetingsListScreenOld({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  MeetingsListScreenOldState createState() => MeetingsListScreenOldState();
}

class MeetingsListScreenOldState extends State<MeetingsListScreenOld> {
  List<User> items = [];
  bool isLoading = false;
  bool hasMore = true;
  int pageSize = 15;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.firstname + " " + widget.user.lastname),
        ),
        body: SfCalendar(
            onTap: (appointmentDetails) {
              if (appointmentDetails.appointments?.length == 1) {
                Get.to(() => MeetingScreen(
                      appointmentDetails: appointmentDetails.appointments![0],
                      user: widget.user,
                    ));
              }
            },
            view: CalendarView.schedule,
            firstDayOfWeek: 1,
            headerHeight: 70,
            headerStyle: const CalendarHeaderStyle(
              backgroundColor: Colors.purple,
              textStyle: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            dataSource: EventDataSource(_getDataSource()),
            //dataSource: _getCalendarDataSource(),
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
            scheduleViewSettings: const ScheduleViewSettings(
                appointmentItemHeight: 50,
                monthHeaderSettings: MonthHeaderSettings(
                    monthFormat: 'MMMM, yyyy',
                    height: 70,
                    textAlign: TextAlign.center,
                    backgroundColor: Colors.purple,
                    monthTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      //fontWeight: FontWeight.w400,
                    )),
                dayHeaderSettings: DayHeaderSettings(
                    dayFormat: 'EEEE',
                    width: 60,
                    dayTextStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    dateTextStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
                weekHeaderSettings: WeekHeaderSettings(
                    startDateFormat: 'dd MMM ',
                    endDateFormat: 'dd MMM, yy',
                    height: 50,
                    textAlign: TextAlign.center,
                    backgroundColor: Colors.white,
                    weekTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    )))));
  }

  List<MeetingModel> _getDataSource() {
    final List<MeetingModel> meetings = <MeetingModel>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    MeetingModel m = MeetingModel();

    m.subject = 'One on one session';
    m.startTime = startTime;
    m.endTime = endTime;
    m.color = Colors.grey;
    m.isAllDay = false;

    meetings.add(m);
    /*
    meetings.add(MeetingModel(0, 'One on one session', startTime, endTime,
        Colors.grey, false, '', '', '', ''));
*/
    return meetings;
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

  Future<DataSource> _getCalendarDataSource() async {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      isAllDay: true,
      subject: 'Meeting',
      color: Colors.blue,
      startTimeZone: '',
      endTimeZone: '',
    ));

    return DataSource(appointments);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class EventDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  EventDataSource(List<MeetingModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).endTime;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).subject;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).color;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  MeetingModel _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final MeetingModel meetingData;
    if (meeting is MeetingModel) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
