import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.password,
    required super.status,
    required super.expDate,
    required super.isTrial,
    required super.activeCons,
    required super.createdAt,
    required super.maxConnections,
    required super.allowedOutputFormats,
    required super.authUserInfo,
    required super.serverInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user_info'] ?? {};
    final serverData = json['server_info'] ?? {};

    return UserModel(
      id: userData['auth'] ?? 0,
      username: userData['username'] ?? '',
      password: userData['password'] ?? '',
      status: userData['status'] ?? '',
      expDate: userData['exp_date'] ?? '',
      isTrial: userData['is_trial'] ?? 0,
      activeCons: userData['active_cons'] ?? 0,
      createdAt: userData['created_at'] ?? '',
      maxConnections: userData['max_connections'] ?? 0,
      allowedOutputFormats: _parseOutputFormats(userData['allowed_output_formats']),
      authUserInfo: AuthUserInfoModel.fromJson(userData),
      serverInfo: ServerInfoModel.fromJson(serverData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_info': {
        'auth': id,
        'username': username,
        'password': password,
        'status': status,
        'exp_date': expDate,
        'is_trial': isTrial,
        'active_cons': activeCons,
        'created_at': createdAt,
        'max_connections': maxConnections,
        'allowed_output_formats': allowedOutputFormats,
      },
      'server_info': (serverInfo as ServerInfoModel).toJson(),
    };
  }

  static List<String> _parseOutputFormats(dynamic formats) {
    if (formats == null) return [];
    if (formats is List) return formats.cast<String>();
    return [];
  }
}

class AuthUserInfoModel extends AuthUserInfo {
  const AuthUserInfoModel({
    required super.status,
    required super.expDate,
    required super.isTrial,
    required super.activeCons,
    required super.createdAt,
    required super.maxConnections,
    required super.allowedOutputFormats,
  });

  factory AuthUserInfoModel.fromJson(Map<String, dynamic> json) {
    return AuthUserInfoModel(
      status: json['status'] ?? '',
      expDate: json['exp_date'] ?? '',
      isTrial: json['is_trial'] ?? 0,
      activeCons: json['active_cons'] ?? 0,
      createdAt: json['created_at'] ?? '',
      maxConnections: json['max_connections'] ?? 0,
      allowedOutputFormats: _parseOutputFormats(json['allowed_output_formats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'exp_date': expDate,
      'is_trial': isTrial,
      'active_cons': activeCons,
      'created_at': createdAt,
      'max_connections': maxConnections,
      'allowed_output_formats': allowedOutputFormats,
    };
  }

  static List<String> _parseOutputFormats(dynamic formats) {
    if (formats == null) return [];
    if (formats is List) return formats.cast<String>();
    return [];
  }
}

class ServerInfoModel extends ServerInfo {
  const ServerInfoModel({
    required super.url,
    required super.port,
    required super.httpsPort,
    required super.serverProtocol,
    required super.rtmpPort,
    required super.timezone,
    required super.timestampNow,
    required super.timeNow,
  });

  factory ServerInfoModel.fromJson(Map<String, dynamic> json) {
    return ServerInfoModel(
      url: json['url'] ?? '',
      port: json['port'] ?? '',
      httpsPort: json['https_port'] ?? '',
      serverProtocol: json['server_protocol'] ?? 'http',
      rtmpPort: json['rtmp_port'] ?? '',
      timezone: json['timezone'] ?? '',
      timestampNow: json['timestamp_now'] ?? 0,
      timeNow: json['time_now'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'port': port,
      'https_port': httpsPort,
      'server_protocol': serverProtocol,
      'rtmp_port': rtmpPort,
      'timezone': timezone,
      'timestamp_now': timestampNow,
      'time_now': timeNow,
    };
  }
}

class AuthCredentialsModel extends AuthCredentials {
  const AuthCredentialsModel({
    required super.serverUrl,
    required super.username,
    required super.password,
    super.m3uUrl,
  });

  factory AuthCredentialsModel.fromJson(Map<String, dynamic> json) {
    return AuthCredentialsModel(
      serverUrl: json['serverUrl'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      m3uUrl: json['m3uUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverUrl': serverUrl,
      'username': username,
      'password': password,
      'm3uUrl': m3uUrl,
    };
  }
}
