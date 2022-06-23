import 'package:alexandrya/meetings/screens/meeting_screen.dart';
import 'package:alexandrya/meetings/models/meeting.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math';

Map<String, List<Meeting>> _dataCollection = <String, List<Meeting>>{};
int meetingHostId = 0;

/// Widget of getting started calendar
class MeetingsListScreen extends StatefulWidget {
  const MeetingsListScreen({Key? key, required this.hostUser})
      : super(key: key);
  final User hostUser;

  @override
  _MeetingsListScreenState createState() => _MeetingsListScreenState();
}

class _MeetingsListScreenState extends State<MeetingsListScreen> {
  _MeetingsListScreenState();

  final _MeetingDataSource _events = _MeetingDataSource(<Meeting>[]);
  final CalendarController _calendarController = CalendarController();

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];

  @override
  void initState() {
    _calendarController.view = CalendarView.schedule;
    _dataCollection = <String, List<Meeting>>{};
    meetingHostId = widget.hostUser.iId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar =
        _getMeetingsListScreen(_calendarController, _events);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hostUser.firstname + " " + widget.hostUser.lastname),
      ),
      body: Container(child: calendar),
    );
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getMeetingsListScreen(CalendarController calendarController,
      CalendarDataSource calendarDataSource) {
    return SfCalendar(
        onTap: (meetingDetails) {
          if (meetingDetails.appointments?.length == 1) {
            Get.to(() => MeetingScreen(
                  meetingDetails: meetingDetails.appointments![0],
                  hostUser: widget.hostUser,
                ));
          }
        },
        controller: calendarController,
        dataSource: calendarDataSource,
        allowedViews: _allowedViews,
        loadMoreWidgetBuilder:
            (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          return FutureBuilder<void>(
            future: loadMoreAppointments(),
            builder: (context, snapShot) {
              return Container(
                  color: Colors.black.withOpacity(0.5),
                  height: double.infinity,
                  /*  height: _calendarController.view == CalendarView.schedule
                      ? 50
                      : double.infinity,*/
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator());
            },
          );
        },
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayCount: 4),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }
}

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    //await Future.delayed(const Duration(seconds: 0));
    final List<Color> _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
    //
    List<Meeting> meetings = <Meeting>[];
    final Random random = Random();

    final url = Uri.parse(
        'https://us-east1-bamboo-dryad-351723.cloudfunctions.net/getmeetingsbyhost?hostid=$meetingHostId');
    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> responseObject = jsonDecode(response.body);

      if (responseObject["meetingslist"] != null) {
        String sStatus = responseObject["status"];
        List meetingsList = responseObject["meetingslist"];
        //
        for (var item in meetingsList) {
          //
          DateTime dateItem = DateTime.parse(item['date_start']);
          String sId = item['id'].toString();
          //
          if (!_dataCollection.containsKey(dateItem.toString() + " " + sId)) {
            //date_from
            DateTime dateFrom = DateTime.parse(item['date_start']);
            DateTime timeFrom = DateTime.parse(item['time_start']);
            dateFrom = dateFrom.add(Duration(hours: timeFrom.hour.toInt()));
            dateFrom = dateFrom.add(Duration(minutes: timeFrom.minute.toInt()));
            //date_to
            DateTime dateTo = DateTime.parse(item['date_end']);
            DateTime timeTo = DateTime.parse(item['time_end']);
            dateTo = dateTo.add(Duration(hours: timeTo.hour.toInt()));
            dateTo = dateTo.add(Duration(minutes: timeTo.minute.toInt()));

            Meeting meet = Meeting(
              id: item['id'],
              subject: item['subject'],
              notes: item['notes'],
              startTime: dateFrom,
              endTime: dateTo,
              color: _colorCollection[random.nextInt(9)],
              isAllDay: false,
              priceIn: Decimal.parse(item['price']),
            );

            meetings.add(meet);

            _dataCollection[dateItem.toString() + " " + sId] = [meet];
          }
        }
      }
    }
    appointments!.addAll(meetings);
    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}



/*
        if (_dataCollection.containsKey(dateAdd)) {
          final List<Appointment> meetings = _dataCollection[dateAdd]!;
          meetings.add(m);
          _dataCollection[dateAdd] = meetings;
        } else {
          _dataCollection[dateAdd] = [m];
        }
*/