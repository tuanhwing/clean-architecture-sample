
class ServerException implements Exception {
  ServerException({this.code, this.message});
  final int? code;
  final String? message;
}

class CacheException implements Exception {
  CacheException({this.message});
  final String? message;
}

class InternalException implements Exception {
  InternalException({this.message});
  final String? message;
}
