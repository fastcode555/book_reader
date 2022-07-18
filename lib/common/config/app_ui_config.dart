import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity_core/core.dart';

class AppUiConfig extends AppUI {
  @override
  Widget loadingPage() {
    return Column(
      children: const [
        Spacer(flex: 1),
        CupertinoActivityIndicator(),
        Spacer(flex: 2),
      ],
    );
  }

  @override
  Widget emptyPage(VoidCallback refreshCallback, String? tip) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: refreshCallback,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(flex: 1),
            const Icon(Icons.hourglass_empty_rounded),
            const SizedBox(height: 10),
            Text(tip ?? CoreIds.noData.tr),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  @override
  Widget errorPage(VoidCallback refreshCallback, String? msg) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: refreshCallback,
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Icon(Icons.error_outline, size: 80),
            const SizedBox(height: 20),
            Text(CoreIds.serverException.tr, textAlign: TextAlign.center),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
