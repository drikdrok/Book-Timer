import 'dart:async';

import 'package:flutter/material.dart';
import "timer.dart";
import "bookdialog.dart";
import "globals.dart" as globals;
import "statspage.dart";

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //List<Widget> timers = [];

  bool floatingAction = true;
  int currentPage = 0;

  PageController controller = PageController(
    initialPage: 0,
  );

  void update(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Timer"),),

      body: PageView(
        controller: controller,
        children: [
          TimerPage(),
          StatsPage(),
        ],

        onPageChanged: (num){
          setState(() {
            currentPage = num;
            floatingAction = (num == 0) ? true : false;
          });
        },

      ),

      floatingActionButton: Visibility(
        visible: floatingAction,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {

              showDialog(
                  context: context,
                  builder: (BuildContext context) => SelectBookDialog(updateParent: update)
              );
              // timers.add(BookTimer());
            });
          },
          child: Icon(Icons.add),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text("Timers")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.tag_faces),
              title: Text("Statistics")
          ),
        ],

        onTap: (index){
          controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }
}


class TimerPage extends StatefulWidget {
  //final Function() updateParent;

 // TimerPage({Key key, @required this.updateParent}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
     return Column(
        children: <Widget>[

          Expanded(
            child: ListView.builder(
              addAutomaticKeepAlives: false,
              cacheExtent: 1000,

              itemCount: globals.timers.length,
              itemBuilder: (BuildContext context, int index){
                return globals.timers[index];
              },

            ),
          ),
        ],
    );
  }
}


