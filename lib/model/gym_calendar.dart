import 'gym_class.dart';

class Calendario {
  String id;
  DateTime fechaDeInicio;
  DateTime fechaDeFinalizacion;
  List<Clase> clases;

  Calendario(
      this.id, this.fechaDeInicio, this.fechaDeFinalizacion, this.clases);
}
