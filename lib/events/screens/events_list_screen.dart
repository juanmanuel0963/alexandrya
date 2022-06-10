import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alexandrya/events/models/event_model.dart';
import 'package:alexandrya/events/screens/event_screen.dart';
import 'package:alexandrya/users/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  EventsListScreenState createState() => EventsListScreenState();
}

class EventsListScreenState extends State<EventsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.firstname + " " + widget.user.lastname),
        ),
        body: SfCalendar(
            onTap: (eventDetails) {
              if (eventDetails.appointments?.length == 1) {
                Get.to(() => EventScreen(
                      eventDetails: eventDetails.appointments![0],
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

  List<EventModel> _getDataSource() {
    final List<EventModel> meetings = <EventModel>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(EventModel(
        'One on one session', startTime, endTime, Colors.grey, false));
    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class EventDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  EventDataSource(List<EventModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  EventModel _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final EventModel meetingData;
    if (meeting is EventModel) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
