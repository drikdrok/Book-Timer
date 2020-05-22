import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import "package:http/http.dart";
import "dart:convert";
import "globals.dart" as globals;

enum Options {delete, mark_as_read}

class BookTimer extends StatefulWidget {
  String title = "Book";
  String thumbnailURL;

  int milliseconds = 0;

  bool finished = false;

  int index;

  int pages  = 0;

  Function() updateParent;


  BookTimer(String title, String thumb, int pages, Function() updateParent){
      this.title = title;
      this.thumbnailURL = thumb;
      this.pages = pages;
      this.updateParent = updateParent;

      index = globals.timers.length;
  }

  @override
  _BookTimerState createState() => _BookTimerState();
}

class _BookTimerState extends State<BookTimer> {

  bool running = false;
  Timer timer;


_BookTimerState(){
    timer = Timer.periodic(Duration(seconds: 1), (timer) { update() ;});
  }

  void update(){
    setState(() {
      if (running) {
        widget.milliseconds += 1000;

        String today = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

        if (!globals.millisecondsOnDays.containsKey(today))
          globals.millisecondsOnDays[today] = 0;

        globals.millisecondsOnDays[today] += 1000;
      }
    });
  }

  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,

        children: <Widget>[Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: FadeInImage.assetNetwork(
                              placeholder: "assets/placeholderbook.jpg",
                              image: widget.thumbnailURL,
                          ),
                        ),
                        Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                  child: SingleChildScrollView(child: Text(widget.title))
                              ),
                            )
                        ),

                        Flexible(
                            flex:2,
                            fit: FlexFit.tight,
                            child: Text("Time: ${globals.format(widget.milliseconds)}")
                        ),

                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                if (widget.finished) {
                                 showDialog(
                                   context: context,
                                   builder: (_) =>  AlertDialog(
                                     title: Text("Mark As Unread?"),
                                     //content: Text("Mark ${widget.title} as unread?"),
                                     actions: <Widget>[
                                       FlatButton(child: Text("No"),
                                         onPressed: (){
                                           Navigator.of(context).pop();
                                         },
                                       ),
                                       FlatButton(child: Text("Yes"),
                                       onPressed: (){
                                         widget.finished = false;
                                         update();
                                         Navigator.of(context).pop();
                                       },)
                                     ],
                                   ),
                                   barrierDismissible: true,

                                 );

                                } else {
                                  running = (running) ? false : true;
                                }
                              });
                            },
                            icon: Icon((widget.finished) ? Icons.check : (running) ? Icons.pause_circle_filled : Icons.play_circle_filled),
                            color: (widget.finished) ? Colors.green : (running) ? Colors.red : Colors.green,
                            iconSize: 40,
                          ),
                        )
                      ],

                    ),
                  ),
                ),
              ],
            ),
          ),


        PopupMenuButton<Options>(
          onSelected: (Options result){
            if (result == Options.delete){
              globals.timers.remove(widget);
              widget.updateParent();
            }else if (result == Options.mark_as_read){
              if (widget.finished) {
                widget.finished = false;
                update();
              } else{
                widget.finished = true;
                running = false;
                update();
              }
            }
          },

          itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
            PopupMenuItem<Options>(
                value: Options.mark_as_read,
                child: Row(
                  children: <Widget>[
                    Icon((widget.finished) ? Icons.undo : Icons.check ),
                    Text((widget.finished) ? "Mark As Unread" : "Mark As Read"),
                  ],
                )
            ),
            PopupMenuItem<Options>(
              value: Options.delete,
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete),
                  Text("Delete"),
                ],
              )
            )
          ],
        )

        ],
      ),
    );
  }
}

