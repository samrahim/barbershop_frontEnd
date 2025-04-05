import 'dart:convert';

import 'package:barberfront/blocs/booking_bloc/booking_bloc.dart';
import 'package:barberfront/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';

void main() async {
  await initializeDateFormatting('fr_FR');
  runApp(
    BlocProvider(
      create:
          (context) =>
              BookingBloc()
                ..add(FetchServices())
                ..add(FetchDays()),
      child: MaterialApp(
        home: BookingPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Réservation"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Services disponibles",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state.services.isEmpty) {
                  return Text(
                    "Aucun service disponible",
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return Column(
                    children:
                        state.services.map((service) {
                          return CheckboxListTile(
                            checkColor: Colors.black,
                            activeColor: Colors.white,
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
                              context.read<BookingBloc>().add(
                                ToggleService(service),
                              );
                            },
                          );
                        }).toList(),
                  );
                }
              },
            ),

            SizedBox(height: 20),
            Text(
              "Jours disponibles",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        state.days.map((day) {
                          final formatedDay = convertDateFormatToCustomObject(
                            day.day!,
                          );
                          Color colors = Colors.black;
                          Color textColor = Colors.white;
                          if (!day.available!) {
                            textColor = Colors.amber;
                            colors = Colors.black;
                          }
                          if (day.isSelected) {
                            textColor = Colors.black;
                            colors = Colors.amber;
                          }
                          return GestureDetector(
                            onTap: () {
                              if (day.available!) {
                                context.read<BookingBloc>().add(
                                  FetchTimeSlots(day.day ?? ""),
                                );
                              } else {}
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 4),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors,

                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    formatedDay.jourSemaine
                                        .substring(0, 3)
                                        .toString(),
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    formatedDay.numJour.toString(),
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                  Text(
                                    formatedDay.mois.substring(0, 3).toString(),
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                );
              },
            ),

            SizedBox(height: 20),
            Text(
              "Horaires disponibles",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state.slots.isNotEmpty) {
                  return GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.2,
                    children:
                        state.slots.map((slot) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  slot,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                } else {
                  return Text(
                    "Aucun créneau disponible",
                    style: TextStyle(color: Colors.white),
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<BookingBloc>().add(
                  MakeBooking(
                    selectedDay: "",
                    selectedServices: [],
                    selectedSlot: '',
                  ),
                );
              },
              child: Text("add book"),
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
  return timesSlotes;
}

FormattedDate convertDateFormatToCustomObject(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);

    final jourFormatter = DateFormat('EEEE', 'fr_FR');
    final jourSemaine = jourFormatter.format(dateTime);

    final numJour = dateTime.day.toString().padLeft(2, '0');

    final year = dateTime.year.toString();

    final moisFormatter = DateFormat('MMMM', 'fr_FR');
    final moisComplet = moisFormatter.format(dateTime);

    return FormattedDate(
      year: year,
      jourSemaine: jourSemaine,
      numJour: numJour,
      mois: moisComplet,
    );
  } catch (e) {
    print(e);
    return FormattedDate(
      jourSemaine: 'Invalide',
      numJour: '00',
      mois: 'Invalide',
      year: 'Invalide',
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

  int currentMinutes = startMinutes;
  while (currentMinutes + duration <= endMinutes) {
    slots.add(formatMinutesToTime(currentMinutes % (24 * 60)));
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
