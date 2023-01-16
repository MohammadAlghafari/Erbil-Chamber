import 'response_type.dart';

class ResponseWrapper<T> {
  T data;
  bool hasError;
  int statusCode;
  String message;
  ResponseType responseType;
  int totalSize;

  @override
  String toString() {
    return 'ResponseWrapper{ data: $data, hasError: $hasError, statusCode: $statusCode, message: $message, responseType: $responseType, totalSize: $totalSize,}';
  }
}
