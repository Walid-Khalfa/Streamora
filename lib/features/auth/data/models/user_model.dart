import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.username,
    required super.password,
    required super.baseUrl,
    required super.status,
    super.expiryDate,
    required super.maxConnections,
    required super.activeConnections,
    required super.isTrial,
    super.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {
    required String baseUrl,
    required String username,
    required String password,
  }) {
    final userData = json['user_info'] ?? {};
    
    DateTime? expiryDate;
    if (userData['exp_date'] != null && userData['exp_date'] != 'Unlimited') {
      try {
        expiryDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(userData['exp_date'].toString()) * 1000,
        );
      } catch (_) {}
    }

    return UserModel(
      username: username,
      password: password,
      baseUrl: baseUrl,
      status: userData['status'] ?? 'Unknown',
      expiryDate: expiryDate,
      maxConnections: int.tryParse(userData['max_connections']?.toString() ?? '1') ?? 1,
      activeConnections: int.tryParse(userData['active_cons']?.toString() ?? '0') ?? 0,
      isTrial: userData['is_trial'] == '1',
      message: userData['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'base_url': baseUrl,
      'status': status,
      'expiry_date': expiryDate?.millisecondsSinceEpoch,
      'max_connections': maxConnections,
      'active_connections': activeConnections,
      'is_trial': isTrial,
      'message': message,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      username: user.username,
      password: user.password,
      baseUrl: user.baseUrl,
      status: user.status,
      expiryDate: user.expiryDate,
      maxConnections: user.maxConnections,
      activeConnections: user.activeConnections,
      isTrial: user.isTrial,
      message: user.message,
    );
  }
}
