import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String password;
  final String status;
  final String expDate;
  final int isTrial;
  final int activeCons;
  final String createdAt;
  final int maxConnections;
  final List<String> allowedOutputFormats;
  final AuthUserInfo authUserInfo;
  final ServerInfo serverInfo;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.status,
    required this.expDate,
    required this.isTrial,
    required this.activeCons,
    required this.createdAt,
    required this.maxConnections,
    required this.allowedOutputFormats,
    required this.authUserInfo,
    required this.serverInfo,
  });

  bool get isActive => status == 'Active';
  bool get isExpired => status == 'Expired' || status == 'Disabled';
  bool get isTrialAccount => isTrial == 1;

  @override
  List<Object?> get props => [
        id,
        username,
        status,
        expDate,
        isTrial,
        activeCons,
        maxConnections,
      ];
}

class AuthUserInfo extends Equatable {
  final String status;
  final String expDate;
  final int isTrial;
  final int activeCons;
  final String createdAt;
  final int maxConnections;
  final List<String> allowedOutputFormats;

  const AuthUserInfo({
    required this.status,
    required this.expDate,
    required this.isTrial,
    required this.activeCons,
    required this.createdAt,
    required this.maxConnections,
    required this.allowedOutputFormats,
  });

  @override
  List<Object?> get props => [
        status,
        expDate,
        isTrial,
        activeCons,
        maxConnections,
        allowedOutputFormats,
      ];
}

class ServerInfo extends Equatable {
  final String url;
  final String port;
  final String httpsPort;
  final String serverProtocol;
  final String rtmpPort;
  final String timezone;
  final int timestampNow;
  final String timeNow;

  const ServerInfo({
    required this.url,
    required this.port,
    required this.httpsPort,
    required this.serverProtocol,
    required this.rtmpPort,
    required this.timezone,
    required this.timestampNow,
    required this.timeNow,
  });

  String get baseUrl => '$serverProtocol://$url:$port';

  @override
  List<Object?> get props => [
        url,
        port,
        httpsPort,
        serverProtocol,
        timezone,
      ];
}

class AuthCredentials extends Equatable {
  final String serverUrl;
  final String username;
  final String password;
  final String? m3uUrl;

  const AuthCredentials({
    required this.serverUrl,
    required this.username,
    required this.password,
    this.m3uUrl,
  });

  @override
  List<Object?> get props => [serverUrl, username, password, m3uUrl];

  AuthCredentials copyWith({
    String? serverUrl,
    String? username,
    String? password,
    String? m3uUrl,
  }) {
    return AuthCredentials(
      serverUrl: serverUrl ?? this.serverUrl,
      username: username ?? this.username,
      password: password ?? this.password,
      m3uUrl: m3uUrl ?? this.m3uUrl,
    );
  }
}
