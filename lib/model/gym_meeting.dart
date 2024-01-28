import 'package:flutter/material.dart';
import 'package:gym/model/class_reservation.dart';



class Meeting {
  String subject;
  DateTime fechaEnLaQueTranscurreLaClase;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<Reserva>? reservas;
  List<String>? idAlumno;
  bool claseLlena;
  String? recurrenceRule;

  Meeting({
    required this.subject,
    required this.fechaEnLaQueTranscurreLaClase,
    required this.startTime,
    required this.endTime,
    this.reservas,
    this.idAlumno,
    this.claseLlena = false,
    this.recurrenceRule,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject' : subject,
      'fechaEnLaQueTranscurreLaClase': fechaEnLaQueTranscurreLaClase.toIso8601String(),
      'horaDeInicio': {
        'hour': startTime.hour,
        'minute': startTime.minute,
      },
      'horaDeFinalizacion': {
        'hour': endTime.hour,
        'minute': endTime.minute,
      },
      'reservas': reservas?.map((reserva) => reserva.toJson()).toList(),
      'idAlumno': idAlumno,
      'claseLlena': claseLlena,
      'recurrenceRule': recurrenceRule,
    };
  }

  static Meeting fromJson(Map<String, dynamic> json) {
    return Meeting(
      subject: json['subject'],
      fechaEnLaQueTranscurreLaClase: DateTime.parse(json['fechaEnLaQueTranscurreLaClase']),
      startTime: TimeOfDay(hour: json['horaDeInicio']['hour'], minute: json['horaDeInicio']['minute']),
      endTime: TimeOfDay(hour: json['horaDeFinalizacion']['hour'], minute: json['horaDeFinalizacion']['minute']),
      reservas: json['appointments']?.map((appointment) => Reserva.fromJson(appointment)).toList(),
      idAlumno: json['idAlumno'],
      claseLlena: json['claseLlena'],
      recurrenceRule: json['recurrenceRule'],
    );
  }

  static Meeting fromMap(Map<String, dynamic> json) {
    final subject = json['subject'];
    final fechaEnLaQueTranscurreLaClase = DateTime.parse(json['fechaEnLaQueTranscurreLaClase']);
    final startTime = TimeOfDay(
        hour: json['horaDeInicio']['hour'], minute: json['horaDeInicio']['minute']);
    final endTime = TimeOfDay(
        hour: json['horaDeFinalizacion']['hour'], minute: json['horaDeFinalizacion']['minute']);

    List<Reserva>? reservas;
    if (json['appointments'] != null) {
      reservas = json['appointments']
          .map((appointment) => Reserva.fromJson(appointment))
          .toList();
    }

    return Meeting(
      subject: subject,
      fechaEnLaQueTranscurreLaClase: fechaEnLaQueTranscurreLaClase,
      startTime: startTime,
      endTime: endTime,
      reservas: reservas,
      idAlumno: json['idAlumno']?.cast<String>(),
      claseLlena: json['claseLlena'] ?? false,
      recurrenceRule: json['recurrenceRule'],
    );
  }



}
