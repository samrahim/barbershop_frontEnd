import 'dart:convert';

import 'package:barberfront/models/hairdress_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getHairDressers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil")),
      body: FutureBuilder(
        future: getHairDressers(),
        builder: (context, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (context, ind) {
                return ListTile(
                  title: Text(snap.data![ind].name ?? ""),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                DetailsScreen(id: snap.data![ind].id ?? 0),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Text("No such element ");
          }
        },
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  int id;
  DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    getServices();
    super.initState();
  }

  Future<List>? slots;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getServices(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                    itemCount: snap.data!.length,
                    itemBuilder: (context, ind) {
                      return ListTile(title: Text(snap.data![ind].name ?? ""));
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getDays(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snap.data!.length,
                    itemBuilder: (context, ind) {
                      return Container(
                        color: Colors.pink,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {});
                                slots = getPlanings(snap.data![ind].day!);
                              },
                              child: Text(
                                convertDateFormatToCustomObject(
                                  snap.data![ind].day ?? "",
                                ).jourSemaine,
                              ),
                            ),
                            Text(
                              convertDateFormatToCustomObject(
                                snap.data![ind].day ?? "",
                              ).numJour.toString(),
                            ),
                            Text(
                              convertDateFormatToCustomObject(
                                snap.data![ind].day ?? "",
                              ).mois.toString(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: slots,
              builder: (context, snap) {
                if (snap.hasData) {
                  if (snap.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snap.data!.length,
                      itemBuilder: (context, ind) {
                        return Text(snap.data![ind]);
                      },
                    );
                  } else {
                    return Text("no creno");
                  }
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
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
  print("day ${DateTime.now().day}");
  print("hours ${DateTime.now().hour}");
  print("minutes ${DateTime.now().minute}");

  // Generate time slots
  int currentMinutes = startMinutes;
  while (currentMinutes + duration <= endMinutes) {
    // Ensure last slot does not exceed end time
    slots.add(
      formatMinutesToTime(currentMinutes % (24 * 60)),
    ); // Keep in 24-hour format
    currentMinutes += duration;
  }
  print("slots------->$slots");
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
