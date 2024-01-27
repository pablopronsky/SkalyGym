import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'gym_class.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
  List<Appointment> _getDataSource(List<Clase> clases) {
    final List<Appointment> appointments = <Appointment>[];
    for (final clase in clases) {
      final DateTime startDate = DateTime(
          clase.fechaEnLaQueTranscurreLaClase.year,
          clase.fechaEnLaQueTranscurreLaClase.month,
          clase.fechaEnLaQueTranscurreLaClase.day,
          clase.horaDeInicio.hour,
          clase.horaDeInicio.minute);
      final DateTime endDate = DateTime(
          clase.fechaEnLaQueTranscurreLaClase.year,
          clase.fechaEnLaQueTranscurreLaClase.month,
          clase.fechaEnLaQueTranscurreLaClase.day,
          clase.horaDeFinalizacion.hour,
          clase.horaDeFinalizacion.minute);
      appointments.add(Appointment(
        startTime: startDate,
        endTime: endDate,
        subject: clase.idAlumno.join(', '),
      ));
    }
    return appointments;
  }
}