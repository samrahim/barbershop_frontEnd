import 'package:equatable/equatable.dart';

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

  Hairdress copyWith({
    required String? name,
    required int? rating,
    required String? image,
    required String? backGroundimage,
  }) {
    return Hairdress(
      backGroundimage: backGroundimage ?? this.backGroundimage,
      image: image ?? this.image,
      name: name ?? this.name,
      rating: rating ?? this.rating,
    );
  }
}

class FormattedDate {
  final String year;
  final String jourSemaine;
  final String numJour;
  final String mois;

  FormattedDate({
    required this.year,
    required this.jourSemaine,
    required this.numJour,
    required this.mois,
  });
}
