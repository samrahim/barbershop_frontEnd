import 'dart:convert';

import 'package:barberfront/blocs/booking_bloc/booking_bloc.dart';
import 'package:barberfront/models/hairdress_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(
    BlocProvider(
      create:
          (context) =>
              BookingBloc()
                ..add(FetchServices())
                ..add(FetchDays()),
      child: MaterialApp(home: BookingPage()),
    ),
  );
}

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Réservation"), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 📌 Services disponibles
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                print("new build");
                if (state.services.isEmpty) {
                  return Text(
                    "no service",
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return Column(
                    children:
                        state.services.map((service) {
                          print(' state.services========>$service');
                          return CheckboxListTile(
                            title: Text(
                              service.name ?? "",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${service.price} DA - ${service.duration} min",
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: service.isSelected,
                            onChanged: (val) {
                              BlocProvider.of<BookingBloc>(
                                context,
                              ).add(ToggleService(service));
                            },
                          );
                        }).toList(),
                  );
                }
              },
            ),

            SizedBox(height: 20),
            Text("Jours disponibles", style: TextStyle(color: Colors.white)),

            // 📌 Jours disponibles
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                return Wrap(
                  children:
                      state.days.map((day) {
                        return GestureDetector(
                          onTap: () {
                            context.read<BookingBloc>().add(
                              FetchTimeSlots(day.day ?? ""),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(day.day ?? ""),
                          ),
                        );
                      }).toList(),
                );
              },
            ),

            SizedBox(height: 20),
            Text("Horaires disponibles", style: TextStyle(color: Colors.white)),

            // 📌 Créneaux horaires
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                return Wrap(
                  children:
                      state.slots.map((slot) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(slot),
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<String>> getPlanings(String day) async {
  List<Planing> plans = [];
  final response = await http.get(
    Uri.parse("http://localhost:8000/hairdresser/1/planing?start_day=$day"),
  );

  List body = json.decode(response.body);
  if (body.isEmpty) {
    return [];
  }
  plans = body.map((e) => Planing.fromJson(e)).toList();

  List<String> timesSlotes = getTimeSlots(
    plans[0].startTime!,
    plans[0].endTime!,
    plans[0].duration!,
  );
  print("retunred value ==========>$timesSlotes");
  return timesSlotes;
}

FormattedDate convertDateFormatToCustomObject(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);

    final jourFormatter = DateFormat('EEEE', 'fr_FR');
    final jourSemaine = jourFormatter.format(dateTime);

    final numJour = dateTime.day;
    final year = dateTime.year;
    final moisFormatter = DateFormat('MMMM', 'fr_FR');
    final moisComplet = moisFormatter.format(dateTime);

    return FormattedDate(
      year: year.toString(),
      jourSemaine: jourSemaine,
      numJour: numJour,
      mois: moisComplet,
    );
  } catch (e) {
    print('Erreur lors de l\'analyse de la date : $e');
    return FormattedDate(
      jourSemaine: 'Invalide',
      numJour: 0,
      mois: 'Invalide',
      year: "invalide",
    );
  }
}

Future<List<Days>> getDays() async {
  List<Days> days = [];
  final response = await http.get(
    Uri.parse("http://localhost:8000/hairdresser/1/availability"),
  );

  Map<String, dynamic> body2 = json.decode(response.body);
  List body = body2['dates'];
  days = body.map((e) => Days.fromJson(e)).toList();
  return days;
}

Future<List<Service>> getServices() async {
  List<Service> services = [];
  final response = await http.get(
    Uri.parse("http://localhost:8000/client/1/service"),
  );

  Map<String, dynamic> body2 = json.decode(response.body);
  List body = body2['hairdresser_services'];
  services = body.map((e) => Service.fromJson(e)).toList();
  return services;
}

List<String> getTimeSlots(String startTime, String endTime, int duration) {
  List<String> slots = [];

  int startMinutes = getMinutesFromTime(startTime);
  int endMinutes = getMinutesFromTime(endTime);

  if (endMinutes < startMinutes) {
    endMinutes += 24 * 60;
  }

  // Generate time slots
  int currentMinutes = startMinutes;
  while (currentMinutes + duration <= endMinutes) {
    // Ensure last slot does not exceed end time
    slots.add(
      formatMinutesToTime(currentMinutes % (24 * 60)),
    ); // Keep in 24-hour format
    currentMinutes += duration;
  }

  return slots;
}

int getMinutesFromTime(String time) {
  List<String> parts = time.split(":");
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  return hours * 60 + minutes;
}

String formatMinutesToTime(int totalMinutes) {
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}
