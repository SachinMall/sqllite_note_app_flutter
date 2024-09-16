class NotesModel {
  final int? id;
  final String title;
  final String descriptions;
  final String date;
  final int timeago;

  NotesModel({
    this.id,
    required this.title,
    required this.descriptions,
    required this.date,
    required this.timeago,
  });

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      descriptions: map['descriptions'] as String,
      date: map['date'] as String,
      timeago: map['timeago'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'descriptions': descriptions,
      'date': date,
      'timeago': timeago,
    };
  }

  @override
  String toString() {
    return 'NotesModel(id: $id, title: $title, descriptions: $descriptions, date: $date, timeago: $timeago)';
  }
}