class BiciRequest {
  BiciRequest(
      {required this.userEmail,
      required this.username,
      required this.bikeNumber,
      required this.requestDate});
  final String userEmail;
  final String username;
  final int bikeNumber;
  final DateTime requestDate;
  DateTime? devolutionDate;
}
