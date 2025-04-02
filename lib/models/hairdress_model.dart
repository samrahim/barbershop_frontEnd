import 'dart:convert';

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

class Service {
  int? id;
  int? hairdresserId;
  String? name;
  int? price;
  int? duration;
  String? createdAt;
  String? updatedAt;

  Service({
    this.id,
    this.hairdresserId,
    this.name,
    this.price,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hairdresserId = json['hairdresser_id'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hairdresser_id'] = hairdresserId;
    data['name'] = name;
    data['price'] = price;
    data['duration'] = duration;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
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

class Days {
  String? day;
  bool? available;

  Days({this.day, this.available});

  Days.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['available'] = available;
    return data;
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
