import 'package:decimal/decimal.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting extends Appointment {
  /// Creates a meeting class with required details.
  ///
  Meeting(
      {id,
      subject,
      notes,
      required DateTime startTime,
      required DateTime endTime,
      color,
      isAllDay,
      priceIn,
      hostIdIn,
      channelIn})
      : price = priceIn,
        hostId = hostIdIn,
        channel = channelIn,
        super(
            id: id,
            subject: subject,
            notes: notes,
            startTime: startTime,
            endTime: endTime,
            color: color,
            isAllDay: isAllDay);
  // Price
  Decimal price;
  // HostId
  int hostId;
  // Channel
  String channel;
  //
  //Meeting(this.id, this.subject, this.notes, this.startTime, this.endTime,
  //    this.color, this.isAllDay, this.price);
  //Meeting(int id, subject, notes, startTime, endTime, color, isAllDay, price);

  //int id;

  /// Event name which is equivalent to subject property of [Appointment].
  //late String subject;

  /// Event notes which is equivalent to notes property of [Appointment].
  //late String notes;

  /// From which is equivalent to start time property of [Appointment].
  // late DateTime startTime;

  /// To which is equivalent to end time property of [Appointment].
  //late DateTime endTime;

  /// Background which is equivalent to color property of [Appointment].
  //late Color color;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  // late bool isAllDay;

}
