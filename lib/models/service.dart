import 'package:equatable/equatable.dart';

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
    this.duration,
    this.price,

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
    int? id,
    String? name,
    int? price,
    int? duration,
    bool? isSelected,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [name, price, isSelected, duration];
}
