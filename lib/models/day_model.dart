import 'package:equatable/equatable.dart';

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
