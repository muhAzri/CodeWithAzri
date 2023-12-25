import 'package:app/app.dart';
import 'package:shared/shared.dart';
import 'package:flutter/material.dart';

class AppRouter {
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
