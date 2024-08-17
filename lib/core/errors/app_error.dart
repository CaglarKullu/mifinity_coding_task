sealed class AppError {
  final String message;

  AppError(this.message);

  @override
  String toString() => message;
}

class NetworkError extends AppError {
  NetworkError(super.message);
}

class ApiError extends AppError {
  ApiError(super.message);
}

class DatabaseError extends AppError {
  DatabaseError(super.message);
}

class ParsingError extends AppError {
  ParsingError(super.message);
}

class UnknownError extends AppError {
  UnknownError(super.message);
}
