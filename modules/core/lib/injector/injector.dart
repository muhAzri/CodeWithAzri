library locator;


import 'package:cwa_core/injector/bloc.dart';
import 'package:cwa_core/injector/services.dart';
import 'package:cwa_core/injector/singleton.dart';
import 'package:get_it/get_it.dart';


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
