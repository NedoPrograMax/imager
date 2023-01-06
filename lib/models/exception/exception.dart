class GenericException implements Exception {
  final String title;
  final String message;

  GenericException({
    required this.title,
    required this.message,
  });
}
