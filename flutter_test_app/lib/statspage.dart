import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "globals.dart" as globals;
import "package:table_calendar/table_calendar.dart";

class StatsPage extends StatefulWidget {


  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  CalendarController calendarController = CalendarController();
  int totalMillisecondsOnDay = 0;

  _StatsPageState(){
    String today = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    if (!globals.millisecondsOnDays.containsKey(today))
      globals.millisecondsOnDays[today] = 0;

    totalMillisecondsOnDay = globals.millisecondsOnDays[today];
  }


  @override
  Widget build(BuildContext context) {

    globals.millisecondsOnDays["10/5/2020"] = 114315;

    int totalMilliseconds = 0;
    int booksCompleted = 0;

    globals.millisecondsOnDays.forEach((key, value) { totalMilliseconds += value;});

    int totalFinishedPages = 0;
    int totalFinishedMilliseconds = 0;

    for (int i = 0; i < globals.timers.length; i++) {
      if (globals.timers[i].finished){
        booksCompleted++;

        totalFinishedPages += globals.timers[i].pages;
        totalFinishedMilliseconds += globals.timers[i].milliseconds;
      }
    }





    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16,),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: Center(child: Text("Total Time Read", style: TextStyle(fontSize: 20,)))),
                    Flexible(flex: 1, child: Center(child: Text("Time Read On Day" , style: TextStyle(fontSize: 20),))),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: Center(child: Text(globals.format(totalMilliseconds), style: TextStyle(fontSize: 20),))),
                    Flexible(flex: 1, child: Center(child: Text(globals.format(totalMillisecondsOnDay), style: TextStyle(fontSize: 20),))),
                  ],
                ),
                SizedBox(height: 26,),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: Center(child: Text("Books Finished" , style: TextStyle(fontSize: 20,)))),
                    Flexible(flex: 1, child: Center(child: Text("Avg. Pages/Minute" , style: TextStyle(fontSize: 20,)))),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: Center(child: Text("$booksCompleted", style: TextStyle(fontSize: 20),))),
                    Flexible(flex: 1, child: Center(child: Text("${(totalFinishedPages / (totalFinishedMilliseconds / 60000)).toStringAsFixed((2))}", style: TextStyle(fontSize: 20),)))
                  ],
                ),
                SizedBox(height: 26,),
              ],
            ),


            TableCalendar(
              calendarController: calendarController,
              startingDayOfWeek: StartingDayOfWeek.monday,

              calendarStyle: CalendarStyle(
                weekdayStyle: TextStyle(color: Colors.black),
                weekendStyle: TextStyle(color: Colors.black),
              ),

              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),

              availableGestures: AvailableGestures.horizontalSwipe,

              onDaySelected: (day, events){
                setState(() {
                  String key = "${day.day}/${day.month}/${day.year}";

                  if (globals.millisecondsOnDays.containsKey(key))
                    totalMillisecondsOnDay = globals.millisecondsOnDays[key];
                  else
                    totalMillisecondsOnDay = 0;

                });
              },

            )
          ],
        ),
      )
    );
  }
}
