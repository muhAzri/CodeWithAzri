import 'package:code_with_azri/router/app_router.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}
