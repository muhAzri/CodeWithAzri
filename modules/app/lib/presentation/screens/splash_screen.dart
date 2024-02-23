import 'dart:async';
import 'package:auth/auth.dart';
import 'package:cwa_core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _authSubscription = Locator()
            .getIt<AuthService>()
            .authStateChanges
            .listen((User? user) {
          navigateToNextScreen(user);
        });
      }
    });
  }

  void navigateToNextScreen(User? user) {
    if (user != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.mainScreen,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.onboardScreen,
      );
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset(
          AssetsManager.logo,
          width: 256.w,
          height: 256.h,
          package: 'cwa_core',
        ),
      ),
    );
  }
}
