import 'package:book_reader/app_pages.dart';
import 'package:book_reader/common/application.dart';
import 'package:book_reader/common/dependency_injection.dart';
import 'package:book_reader/res/colours.dart';
import 'package:book_reader/res/themes.dart';
import 'package:book_reader/res/translation_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';
import 'package:infinity_core/core.dart';
import 'package:infinity_core/model/language_model.dart';

import 'debug_page.dart';

void main() async {
  int date = DateTime.now().millisecondsSinceEpoch;
  Global.init(
    () async {
      await DependencyInjection.init();
      //初始化网络配置
      debugPrint("冷启动时间${DateTime.now().millisecondsSinceEpoch - date}");
      // if (kDebugMode) {
      PluginManager.instance
        ..register(const MonitorPlugin())
        ..register(const MonitorActionsPlugin())
        ..register(const WidgetInfoInspector())
        ..register(const WidgetInfoInspector())
        ..register(const WidgetDetailInspector())
        ..register(const ColorSucker())
        ..register(AlignRuler())
        ..register(const ColorPicker()) // 新插件
        ..register(const TouchIndicator()) // 新插件
        ..register(Performance())
        ..register(const ShowCode())
        ..register(const MemoryInfoPage())
        ..register(CpuInfoPage())
        ..register(const DeviceInfoPanel())
        ..register(Console())
        ..register(DioInspector(dio: HttpManager.instance.getDio()));
      runApp(const UMEWidget(child: MyApp(), enable: true)); // 初始化
    },
    languages: [
      LanguageModel('English', 'en', 'US'),
      LanguageModel('简体中文', 'zh-Hans', 'CN'),
      LanguageModel('繁体中文', 'zh-Hant', 'HK'),
      LanguageModel('ไทย', 'th', 'TH'),
      LanguageModel('हिन्दी', 'hi', 'IN'),
    ],
  );
}

class MyApp extends BaseView {
  const MyApp({Key? key}) : super(key: key);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Monitor.init(Get.context!, actions: [
        MonitorActionWidget(title: "DebugPage", onTap: () => NavigatorUtil.pushName(DebugPage.routeName)),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: CoreConfig.kProfileMode,
      scrollBehavior: MyCustomScrollBehavior(),
      logWriterCallback: Logger.write,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      navigatorObservers: [Application.instance.routeObserver],
      unknownRoute: AppPages.unknownRoute,
      locale: LanguageUtil.initLanguage().toLocale(),
      theme: Themes.theme(Colours.mainColor),
      translations: TranslationService(),
      builder: (ctx, child) {
        return OKToast(
          backgroundColor: Colors.black54,
          textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          radius: 20.0,
          position: ToastPosition.bottom,
          child: GestureDetector(
            child: Material(child: child),
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
          ),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, PointerDeviceKind.mouse};
}
