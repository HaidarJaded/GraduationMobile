class HttpException implements Exception {
  final int statusCode;
  final String? message;

  HttpException(this.statusCode, [this.message]);

  @override
  String toString() {
    if (message != null) {
      return 'Error: $message';
    }
    switch (statusCode) {
      case 400:
        return 'Error: Bad Request';
      case 401:
        return 'Error: Unauthenticated! Please log back in';
      case 403:
        return 'Error: Forbidden';
      case 404:
        return 'Error: Not Found';
      case 500:
        return 'Error: Internal Server Error';
      case 503:
        return 'Error: Service Unavailable';
      default:
        return 'Error: Unknown Error with status code $statusCode';
    }
  }
}
