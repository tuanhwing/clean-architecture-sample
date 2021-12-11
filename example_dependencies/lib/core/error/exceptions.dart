
class ServerException implements Exception {
  const ServerException({this.code, this.message});
  final int? code;
  final String? message;
}

class CacheException implements Exception {
  const CacheException({this.message});
  final String? message;
}

class InternalException implements Exception {
  const InternalException({this.message});
  final String? message;
}
