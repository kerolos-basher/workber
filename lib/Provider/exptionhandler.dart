class HttpExption implements Exception {
  final String message;
  HttpExption(this.message);

  @override
  String toString() {
    return message;
  }
}
