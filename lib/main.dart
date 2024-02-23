import 'package:code_with_azri/firebase_options.dart';
import 'package:cwa_core/core.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Locator().setupDepedency();

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}
