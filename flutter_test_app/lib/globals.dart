library flutter_test_app.globals;
import "package:flutter/material.dart";
import 'package:fluttertestapp/timer.dart';

List<BookTimer> timers = [];

Map<String, int> millisecondsOnDays = Map<String, int>();


String format(int milliseconds) {
  int hundreds = (milliseconds / 10).truncate();
  int seconds = (hundreds / 100).truncate();
  int minutes = (seconds / 60).truncate();
  int hours = (minutes / 60).truncate();

  String minutesStr = (minutes % 60).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');
  String hourStr = (hours % 60).toString().padLeft(2, "0");

  return "$hourStr:$minutesStr:$secondsStr";
}