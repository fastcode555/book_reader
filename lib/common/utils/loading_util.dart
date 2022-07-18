import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingUtil {
  static void show() {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
      indicator: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SpinKitWave(
          size: 40,
          itemBuilder: (_, index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          },
        ),
      ),
    );
    // ..customAnimation = CustomAnimation();
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
