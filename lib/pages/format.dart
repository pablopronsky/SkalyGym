/*
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Clase> _clases = [
    Clase(DateTime.now(), TimeOfDay(hour: 7, minute: 0),
        TimeOfDay(hour: 8, minute: 0), [], false, [], null),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion Flutter Calendar Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Syncfusion Flutter Calendar Example'),
        ),
        body: SfCalendar(
          // Set the dataSource property of the calendar with the list of classes.
          dataSource: _clases,
          // Set the appointmentBuilder property to customize the appointment UI.
          appointmentBuilder:
              (BuildContext context, CalendarAppointment appointment) {
            return Container(
              // Set the color of the appointment.
              color: appointment.isRecurrent
                  ? Colors.green
                  : appointment.isBooked
                      ? Colors.red
                      : Colors.blue,
              // Set the text of the appointment.
              child: Text(
                appointment.subject,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
          // Set the onTap property to handle the tap event on the appointment.
          onTap: (CalendarAppointment appointment) {
            // Check if the appointment is already booked.
            if (!appointment.isBooked) {
              // Create a new reservation for the appointment.
              Reserva reserva = Reserva(
                  alumnoId: '123456789',
                  fecha: appointment.startTime,
                  horaInicio: appointment.startTime,
                  horaFin: appointment.endTime);

              // Add the reservation to the appointment.
              appointment.reservations.add(reserva);

              // Update the state of the widget.
              setState(() {
                _clases = [..._clases];
              });
            }
          },
        ),
      ),
    );
  }
*/
