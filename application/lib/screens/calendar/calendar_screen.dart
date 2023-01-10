import 'package:application/data_class/events_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late final db =
      FirebaseFirestore.instance.collection("userList").doc(user!.uid).get();
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
        body: FutureBuilder(
          future: db,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final eventData = snapshot.data!.data();
              final List eventInfo = eventData!["events"];
              final List<Event> myEvents = [];
              for (var i = 0; i < eventInfo.length; i++) {
                myEvents.add(Event.fromJson(eventInfo[i]));
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.12, 20, 0),
                  child: SingleChildScrollView(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 350,
                        height: 480,
                        child: SfCalendar(
                          dataSource: EventDataSource(myEvents),
                          showNavigationArrow: true,
                          view: CalendarView.month,
                          // by default the month appointment display mode set as Indicator, we can
                          // change the display mode as appointment using the appointment display
                          // mode property
                          monthViewSettings: const MonthViewSettings(
                              appointmentDisplayMode:
                                  MonthAppointmentDisplayMode.indicator,
                              showAgenda: true),
                        ),
                      ),
                    ],
                  )),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  List<Event> _getDataSource() {
    final List<Event> events = <Event>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    return events;
  }
}
