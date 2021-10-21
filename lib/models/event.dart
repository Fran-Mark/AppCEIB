class Event {
  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isUrgent = false,
  });
  final String id;
  final DateTime date;
  final String title;
  final String description;
  bool isUrgent;
}
