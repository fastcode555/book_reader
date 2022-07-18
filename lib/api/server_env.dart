import 'package:flutter/foundation.dart';

import 'apis.dart';

/// 服务端接口网络环境，Debug 模式默认 `development`，其他模式默认 `production`
enum ServerEnv {
  /// 内网测试
  development,

  /// 外网测试
  staging,

  /// 外网生产
  production,
}

extension ServerEnvRaw on ServerEnv {
  /// 从 dart-define 获取服务端接口环境配置
  static ServerEnv fromEnvironment({ServerEnv? defaultValue}) =>
      ServerEnvRaw.parse(const String.fromEnvironment('SERVER_ENV'), defaultValue: defaultValue);

  static ServerEnv parse(String raw, {ServerEnv? defaultValue}) {
    switch (raw.toLowerCase()) {
      case "dev":
      case "develop":
      case "development":
        return ServerEnv.development;
      case "stg":
      case "stage":
      case "staging":
        return ServerEnv.staging;
      case "prd":
      case "prod":
      case "product":
      case "production":
        return ServerEnv.production;
      default:
        return defaultValue ?? (kDebugMode ? ServerEnv.development : ServerEnv.production);
    }
  }

  String toShortString() {
    return this.toString().split('.').last;
  }
}

extension ServerEnvs on ServerEnv {
  String get host {
    switch (this) {
      case ServerEnv.development:
        return Apis.hostTest;
      case ServerEnv.staging:
        return Apis.hostPrepare;
      case ServerEnv.production:
      default:
        return Apis.host;
    }
  }

  static ServerEnv parseFrom(String? host) =>
      ServerEnv.values.firstWhere((v) => v.host == host, orElse: () => ServerEnv.development);
}
