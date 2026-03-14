import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String password;
  final String baseUrl;
  final String status;
  final DateTime? expiryDate;
  final int maxConnections;
  final int activeConnections;
  final bool isTrial;
  final String? message;

  const User({
    required this.username,
    required this.password,
    required this.baseUrl,
    required this.status,
    this.expiryDate,
    required this.maxConnections,
    required this.activeConnections,
    required this.isTrial,
    this.message,
  });

  bool get isActive => status == 'Active';
  bool get isExpired => expiryDate != null && DateTime.now().isAfter(expiryDate!);
  int get availableConnections => maxConnections - activeConnections;

  @override
  List<Object?> get props => [
        username,
        password,
        baseUrl,
        status,
        expiryDate,
        maxConnections,
        activeConnections,
        isTrial,
        message,
      ];

  User copyWith({
    String? username,
    String? password,
    String? baseUrl,
    String? status,
    DateTime? expiryDate,
    int? maxConnections,
    int? activeConnections,
    bool? isTrial,
    String? message,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      baseUrl: baseUrl ?? this.baseUrl,
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      maxConnections: maxConnections ?? this.maxConnections,
      activeConnections: activeConnections ?? this.activeConnections,
      isTrial: isTrial ?? this.isTrial,
      message: message ?? this.message,
    );
  }
}
