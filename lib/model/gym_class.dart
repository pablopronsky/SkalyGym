import 'package:flutter/material.dart';

import 'class_reservation.dart';

class Clase {
  String id;
  DateTime fechaEnLaQueTranscurreLaClase;
  TimeOfDay horaDeInicio;
  TimeOfDay horaDeFinalizacion;
  List<Reserva> reservas;
  String idAlumno;
  bool claseLlena;

  Clase(this.id, this.fechaEnLaQueTranscurreLaClase, this.horaDeInicio,
      this.horaDeFinalizacion, this.reservas, this.claseLlena, this.idAlumno);
}
