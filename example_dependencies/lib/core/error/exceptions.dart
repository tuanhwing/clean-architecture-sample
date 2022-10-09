
///ServerException
class ServerException implements Exception {
  ///Constructor
  const ServerException({this.code, this.message});
  ///code
  final int? code;
  ///message
  final String? message;
}

///CacheException
class CacheException implements Exception {
  ///Constructor
  const CacheException({this.message});
  ///message
  final String? message;
}

///InternalException
class InternalException implements Exception {
  ///Constructor
  const InternalException({this.message});
  ///message
  final String? message;
}
