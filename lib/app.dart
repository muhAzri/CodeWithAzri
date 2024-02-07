import 'package:code_with_azri/router/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
        Locale('de'),
        Locale('ja'),
      ],
      path: 'assets/locale',
      fallbackLocale: const Locale('en'),
      child: ScreenUtilInit(
        designSize: const Size(393, 847),
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: globalNavigatorKey,
            onGenerateRoute: appRouter.onGenerateRoute,
            debugShowCheckedModeBanner: kDebugMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}
