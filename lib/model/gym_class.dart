import 'package:flutter/material.dart';

import 'class_reservation.dart';

class Clase {
  String id;
  DateTime fechaEnLaQueTranscurreLaClase;
  TimeOfDay horaDeInicio;
  TimeOfDay horaDeFinalizacion;
  List<Reserva> reservas;
  List<String> idAlumno;
  bool claseLlena;

  Clase(this.id, this.fechaEnLaQueTranscurreLaClase, this.horaDeInicio,
      this.horaDeFinalizacion, this.reservas, this.claseLlena, this.idAlumno);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaEnLaQueTranscurreLaClase': fechaEnLaQueTranscurreLaClase.toIso8601String(),
      'horaDeInicio': {'hour': horaDeInicio.hour, 'minute': horaDeInicio.minute},
      'horaDeFinalizacion': {'hour': horaDeFinalizacion.hour, 'minute': horaDeFinalizacion.minute},
      'reservas': reservas.map((reserva) => reserva.toJson()).toList(),
      'idAlumno': idAlumno,
      'claseLlena': claseLlena,
    };
  }
}

