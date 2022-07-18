import 'package:book_reader/api/apis.dart';
import 'package:book_reader/common/application.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:infinity_core/core.dart';

class CustomHttpManager extends HttpManager {
  String? _deviceId;

  CustomHttpManager() {
    InfinityCore.getDeviceId().then((value) {
      _deviceId = value;
      Monitor.instance.putsConsole(["DeviceID:", _deviceId ?? ""]);
    });
  }

  @override
  String buildBaseUrl() => Apis.resolveHost();

  @override
  String? getToken() => Application.instance.getToken();

  @override
  String? getDeviceId() => _deviceId;

  @override
  Map<String, dynamic> buildQueryParameters(
    Map<String, dynamic>? parameters,
    String? url, {
    String method = "get",
    String? csrf,
  }) {
    Map<String, dynamic> map = Map<String, dynamic>();
    Map queryParameters = Map<String, dynamic>();
    if (parameters != null) {
      queryParameters.addAll(parameters);
    }

    String deviceType;
    if (GetPlatform.isIOS) {
      deviceType = "iOS";
    } else if (GetPlatform.isAndroid) {
      deviceType = "Android";
    } else if (GetPlatform.isMacOS) {
      deviceType = "MacOs";
    } else {
      deviceType = "Web";
    }
    int t = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    queryParameters["os"] = deviceType;
    queryParameters["oss"] = _deviceId;
    queryParameters["t"] = t.toString();
    queryParameters["device_id"] = _deviceId;
    if (!TextUtil.isEmpty(getToken())) {
      queryParameters["token"] = getToken();
    }
    if (getToken() != null && getToken()!.isNotEmpty) {
      queryParameters["uid"] = Application.instance.getUid();
    }
    if (queryParameters.isNotEmpty) {
      queryParameters.forEach((key, value) {
        map[key] = value;
      });
    }
    return map;
  }

  @override
  ResultData interceptResultData(ResultData data) {
    return data;
  }
}
