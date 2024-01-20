import 'package:flutter/material.dart';

class Reserva {
  String id;
  DateTime fechaReserva;
  TimeOfDay horaDeInicio;
  TimeOfDay horaDeFinalizacion;
  String idAlumno;
  String idClase;

  Reserva(this.id, this.fechaReserva, this.horaDeInicio,
      this.horaDeFinalizacion, this.idAlumno, this.idClase);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaEnLaQueTranscurreLaReserva': fechaReserva.toIso8601String(),
      'horaDeInicio': {'hour': horaDeInicio.hour, 'minute': horaDeInicio.minute},
      'horaDeFinalizacion': {'hour': horaDeFinalizacion.hour, 'minute': horaDeFinalizacion.minute},
      'idAlumno': idAlumno,
      'idClase': idClase,
    };
  }
  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      json['id'] as String,
      DateTime.parse(json['fechaEnLaQueTranscurreLaReserva']),
      TimeOfDay(hour: json['horaDeInicio']['hour'] as int, minute: json['horaDeInicio']['minute'] as int),
      TimeOfDay(hour: json['horaDeFinalizacion']['hour'] as int, minute: json['horaDeFinalizacion']['minute'] as int),
      json['idAlumno'] as String,
      json['idClase'] as String,
    );
  }
}
