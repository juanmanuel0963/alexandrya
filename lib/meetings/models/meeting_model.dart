import 'package:flutter/material.dart';

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class MeetingModel {
  /// Creates a meeting class with required details.
  ///
  /*
  MeetingModel(this.id, this.meetingName, this.from, this.to, this.background,
      this.isAllDay, this.dateFrom, this.dateTo, this.timeFrom, this.timeTo);
*/

  int? id;

  /// Event name which is equivalent to subject property of [Appointment].
  late String subject;

  /// Event notes which is equivalent to notes property of [Appointment].
  late String notes;

  /// From which is equivalent to start time property of [Appointment].
  late DateTime startTime;

  /// To which is equivalent to end time property of [Appointment].
  late DateTime endTime;

  /// Background which is equivalent to color property of [Appointment].
  late Color color;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  late bool isAllDay;
}
