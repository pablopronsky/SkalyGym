import 'package:flutter/material.dart';

import '../model/gym_class.dart';

class ClaseServicio{

  List<Clase> generarClasesSemanal() {
    List<Clase> clases = [];
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

    while (startDate.isBefore(endDate)) {
      if (startDate.weekday == DateTime.monday ||
          startDate.weekday == DateTime.wednesday ||
          startDate.weekday == DateTime.friday) {
        for (int i = 7; i <= 9; i++) {
          clases.add(generarClase(startDate, i));
        }
        for (int i = 16; i <= 20; i++) {
          clases.add(generarClase(startDate, i));
        }
      } else if (startDate.weekday == DateTime.tuesday ||
          startDate.weekday == DateTime.thursday) {
        for (int i = 16; i <= 20; i++) {
          clases.add(generarClase(startDate, i));
        }
      } else if (startDate.weekday == DateTime.saturday) {
        for (int i = 7; i <= 11; i++) {
          clases.add(generarClase(startDate, i));
        }
      }

      startDate = startDate.add(Duration(days: 1));
    }

    return clases;
  }

  Clase generarClase(DateTime date, int hour) {
    DateTime claseDate = DateTime(date.year, date.month, date.day, hour);
    return Clase(
      claseDate.toString(),
      claseDate,
      TimeOfDay(hour: hour, minute: 0),
      TimeOfDay(hour: hour + 1, minute: 0),
      [],
      false,
      [],
    );
  }
}
