import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/services/auth_services.dart';
import 'package:shared/shared.dart';

class SplashScreen extends StatefulWidget {
  final AuthService? authService;
  const SplashScreen({super.key, this.authService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();

    Future.delayed(const Duration(seconds: 3), () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.mainScreen,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.onboardScreen,
          (route) => false,
        );
      }
    });
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
          package: 'shared',
        ),
      ),
    );
  }
}
