import 'package:book_reader/api/api_service.dart';
import 'package:book_reader/api/apis.dart';
import 'package:book_reader/api/http_manager.dart';
import 'package:book_reader/common/config/app_image_config.dart';
import 'package:book_reader/common/config/app_ui_config.dart';
import 'package:book_reader/database/db_manager.dart';
import 'package:infinity_core/core.dart';

class DependencyInjection {
  static Future<void> init() async {
    await DbManager.instance.init();
    Apis.init();
    HttpManager.init(CustomHttpManager());
    ImageLoader.init(AppImageConfig());
    AppUI.init(AppUiConfig());
    Get.put(ApiService());
  }
}
