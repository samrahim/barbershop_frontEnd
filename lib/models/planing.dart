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
