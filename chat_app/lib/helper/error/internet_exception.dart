import 'dart:io';

abstract class InternetException implements Exception {
  final dynamic message;
  final int? statusCode;

  const InternetException({this.message, this.statusCode});
}

class NoInternetException extends InternetException {}

class DatabaseException extends InternetException {
  const DatabaseException({
    dynamic message,
    int? statusCode,
  }) : super(
          message: message,
          statusCode: statusCode,
        );
}