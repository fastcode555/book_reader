import 'package:book_reader/api/server_env.dart';
import 'package:infinity_core/core.dart';

class Apis {
  static const String host = "https://api-stag.super-server5.co/api/";
  static const String hostTest = "https://api.super-server5.co/api/";
  static const String hostPrepare = "https://api-stag.super-server5.co/api/";

  static const String hostTestKey = "host_test_key";

  static String _host = host;
  static ServerEnv server = ServerEnvRaw.fromEnvironment();

  static String resolveHost() {
    return _host;
  }

  static void init() async {
    if (CoreConfig.debug) {
      final host = SpUtil.getString(hostTestKey);
      // 优先级：环境变量 -> 本地设置 -> 默认内网
      server = ServerEnvRaw.fromEnvironment(defaultValue: ServerEnvs.parseFrom(host));
      _host = server.host;
    } else {
      server = ServerEnv.production;
      _host = server.host;
    }
  }

  static Future switchHost(String? newHost) async {
    _host = newHost ?? _host;
    server = ServerEnvs.parseFrom(newHost);
    await SpUtil.putString(hostTestKey, _host);
  }

  static const String login = 'login';
}
