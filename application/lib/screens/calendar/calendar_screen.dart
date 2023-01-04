import 'package:application/data_class/events_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text("Calendar", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.grey.shade100,
        ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.12, 20, 0),
          child: SingleChildScrollView( child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                height: 480,
                child: SfCalendar(
                  dataSource: EventDataSource(_getDataSource()),
                  showNavigationArrow: true,
                  view: CalendarView.month,
                  // by default the month appointment display mode set as Indicator, we can
                  // change the display mode as appointment using the appointment display
                  // mode property
                  monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode: MonthAppointmentDisplayMode.indicator, showAgenda: true),
    ),
              ),
            ],
          )),
        ),
      ));
    
  }

  List<Event> _getDataSource() {
  final List<Event> events = <Event>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  events.add(Event(
      'Conference', startTime, endTime, const Color(0xFF0F8644), false));
  return events;
}
}
