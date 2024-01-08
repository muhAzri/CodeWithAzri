library locator;

import 'package:get_it/get_it.dart';
import 'package:locator/bloc_factory.dart';
import 'package:locator/services_factory.dart';
import 'package:locator/singleton.dart';

class Locator {
  final GetIt getIt = GetIt.instance;

  void setupDepedency() {
    setupSingletonDepedencies(getIt);

    //Service Factory
    setUpServicesDepedencies(getIt);

    //Bloc Factory
    setUpBlocDepedencies(getIt);
  }
}
