import 'package:code_with_azri/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 847),
      builder: (context, child) {
        return MaterialApp(
          onGenerateRoute: appRouter.onGenerateRoute,
          debugShowCheckedModeBanner: kDebugMode,
        );
      },
    );
  }
}
