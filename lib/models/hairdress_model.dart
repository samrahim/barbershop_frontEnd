import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

class Hairdress {
  int? id;
  String? name;
  int? rating;
  String? image;
  String? backGroundimage;

  Hairdress({
    this.id,
    this.name,
    this.rating,
    this.image,
    this.backGroundimage,
  });

  Hairdress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    image = json['image'];
    backGroundimage = json['backGroundimage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rating'] = rating;
    data['image'] = image;
    data['backGroundimage'] = backGroundimage;
    return data;
  }
}

Future<List<Hairdress>> getHairDressers() async {
  List<Hairdress> hairdressers = [];
  final response = await http.get(
    Uri.parse("http://localhost:8000/hairdresser/hairdressers"),
  );
  List body = json.decode(response.body);
  hairdressers = body.map((e) => Hairdress.fromJson(e)).toList();
  return hairdressers;
}

class Service extends Equatable {
  int? id;
  int? hairdresserId;
  String? name;
  int? price;
  int? duration;
  bool isSelected;

  Service({
    this.id,
    this.hairdresserId,
    this.name,
    this.price,
    this.duration,

    this.isSelected = false,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      hairdresserId: json['hairdresser_id'],
      id: json['id'],
      name: json['name'],
      price: json['price'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hairdresser_id'] = hairdresserId;
    data['name'] = name;
    data['price'] = price;
    data['duration'] = duration;

    return data;
  }

  Service copyWith({
    String? name,
    int? price,
    int? duration,
    bool? isSelected,
  }) {
    return Service(
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [name, price, isSelected, duration];
}

class Reservation {
  late int clientId;
}

class FormattedDate {
  final String jourSemaine;
  final int numJour;
  final String mois;
  final String year;
  FormattedDate({
    required this.year,
    required this.jourSemaine,
    required this.numJour,
    required this.mois,
  });
}

class Days extends Equatable {
  String? day;
  bool? available;
  final bool isSelected;
  Days({this.day, this.available, this.isSelected = false});

  factory Days.fromJson(Map<String, dynamic> json) {
    return Days(day: json['day'], available: json['available']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['available'] = available;
    return data;
  }

  @override
  List<Object?> get props => [available, day, isSelected];
  Days copyWith({String? day, bool? available, bool? isSelected}) {
    return Days(
      day: day ?? this.day,
      available: available ?? this.available,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class Planing {
  int? id;
  int? hairdresserId;
  String? startTime;
  String? endTime;
  int? duration;

  Planing({
    this.id,
    this.hairdresserId,
    this.startTime,
    this.endTime,
    this.duration,
  });

  Planing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hairdresserId = json['hairdresser_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hairdresser_id'] = hairdresserId;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['duration'] = duration;
    return data;
  }
}
