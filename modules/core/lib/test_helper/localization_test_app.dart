import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LocalizationTestApp extends StatelessWidget {
  final Widget? child;
  final List<NavigatorObserver>? navigatorObservers;
  final Map<String, Widget Function(BuildContext)>? routes;
  const LocalizationTestApp(
      {super.key, this.child, this.routes, this.navigatorObservers});

  @override
  Widget build(BuildContext context) {
    EasyLocalization.logger.enableBuildModes = [];
    return EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      path: 'l10n',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: ScreenUtilInit(
        designSize: const Size(393, 847),
        child: GlobalLoaderOverlay(
          child: MaterialApp(
            navigatorObservers: navigatorObservers ?? const <NavigatorObserver>[],
            home: child,
            routes: routes ?? const <String, WidgetBuilder>{},
          ),
        ),
      ),
      errorWidget: (message) {
        return Center(
          child: Text("Error Localization: $message"),
        );
      },
    );
  }
}