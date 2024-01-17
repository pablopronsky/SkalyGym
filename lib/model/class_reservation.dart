import 'package:flutter/material.dart';

class Reserva {
  String id;
  DateTime fechaEnLaQueTranscurreLaReserva;
  TimeOfDay horaDeInicio;
  TimeOfDay horaDeFinalizacion;
  String idAlumno;
  String idClase;

  Reserva(this.id, this.fechaEnLaQueTranscurreLaReserva, this.horaDeInicio,
      this.horaDeFinalizacion, this.idAlumno, this.idClase);
}
