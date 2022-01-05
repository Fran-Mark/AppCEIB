class Event {
  Event({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.place,
    this.link,
    this.isUrgent = false,
  });
  final String id;
  final String title;
  final String description;
  final DateTime? date;
  final String? place;
  final String? link;
  bool isUrgent;
}
