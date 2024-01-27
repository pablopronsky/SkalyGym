import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'class_reservation.dart';

class Clase extends CalendarDataSource{
  DateTime fechaEnLaQueTranscurreLaClase;
  TimeOfDay horaDeInicio;
  TimeOfDay horaDeFinalizacion;
  List<Reserva> reservas;
  List<String> idAlumno;
  bool claseLlena;
  String? recurrenceRule;

  Clase(
      this.fechaEnLaQueTranscurreLaClase,
      this.horaDeInicio,
      this.horaDeFinalizacion,
      this.reservas,
      this.claseLlena,
      this.idAlumno,
      this.recurrenceRule);

  Map<String, dynamic> toJson() {
    return {
      'fechaEnLaQueTranscurreLaClase':
      fechaEnLaQueTranscurreLaClase.toIso8601String(),
      'horaDeInicio': {
        'hour': horaDeInicio.hour,
        'minute': horaDeInicio.minute
      },
      'horaDeFinalizacion': {
        'hour': horaDeFinalizacion.hour,
        'minute': horaDeFinalizacion.minute
      },
      'reservas': reservas.map((reserva) => reserva.toJson()).toList(),
      'idAlumno': idAlumno,
      'claseLlena': claseLlena,
      'esRecurrente': recurrenceRule,
    };
  }

  factory Clase.fromJson(Map<String, dynamic> json) {
    return Clase(
      DateTime.parse(json['fechaEnLaQueTranscurreLaClase']),
      TimeOfDay(
          hour: json['horaDeInicio']['hour'],
          minute: json['horaDeInicio']['minute']),
      TimeOfDay(
          hour: json['horaDeFinalizacion']['hour'],
          minute: json['horaDeFinalizacion']['minute']),
      (json['reservas'] as List<dynamic>)
          .map((reservaJson) => Reserva.fromJson(reservaJson))
          .toList(),
      json['claseLlena'],
      (json['idAlumno'] as List<dynamic>).cast<String>(),
      json['recurrenceRule'],
    );
  }
}
