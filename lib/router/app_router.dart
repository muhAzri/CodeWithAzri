import 'package:app/app.dart';
import 'package:app/presentation/screens/main_screen.dart';
import 'package:auth/auth.dart';
import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locator/locator.dart';
import 'package:shared/shared.dart';
import 'package:flutter/material.dart';

class AppRouter {
  final Locator locator = Locator();

  Route? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return Builder(
          builder: (BuildContext context) {
            switch (settings.name) {
              case AppRoutes.splashScreen:
                return const SplashScreen();

              case AppRoutes.onboardScreen:
                return const OnboardScreen();

              case AppRoutes.signUpScreen:
                return BlocProvider(
                  create: (context) => locator.getIt<SignUpBloc>(),
                  child: const SignUpScreen(),
                );

              case AppRoutes.signInScreen:
                return BlocProvider(
                  create: (context) => locator.getIt<SignInBloc>(),
                  child: SignInScreen(),
                );

              case AppRoutes.mainScreen:
                return const MainScreen();

              default:
                return const NamedRouteNotFound();
            }
          },
        );
      },
    );
  }
}

class NamedRouteNotFound extends StatelessWidget {
  const NamedRouteNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Check Named Route',
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
    );
  }
}
