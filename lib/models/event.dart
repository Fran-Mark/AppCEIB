class Event {
  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.timestamp,
    this.date,
    this.place,
    this.link,
    this.isUrgent = false,
  });
  final String id;
  final String title;
  final String description;
  final String author;
  final DateTime timestamp;
  final DateTime? date;
  final String? place;
  final String? link;
  bool isUrgent;
}
