import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TestApp extends StatelessWidget {
  final Widget? home;
  final Map<String, Widget Function(BuildContext)>? routes;
  const TestApp({super.key, this.home, this.routes});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(393, 847),
    );
    return GlobalLoaderOverlay(
      child: MaterialApp(
        home: home,
        routes: routes ?? const <String, WidgetBuilder>{},
      ),
    );
  }
}
