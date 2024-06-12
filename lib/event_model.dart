class Event {
  String name;
  String club;
  String status;
  String purpose;
  String room;
  DateTime beginTime;
  DateTime endTime;
  String? id;

  Event({
    required this.name,
    required this.club,
    required this.status,
    required this.purpose,
    required this.room,
    required this.beginTime,
    required this.endTime,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'club': club,
      'status': status,
      'purpose': purpose,
      'room': room,
      'beginTime': beginTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'id': id,
    };
  }

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      club: json['club'],
      status: json['status'],
      purpose: json['purpose'],
      room: json['room'],
      beginTime: DateTime.parse(json['beginTime']),
      endTime: DateTime.parse(json['endTime']),
      id: json['id'],
    );
  }
}
