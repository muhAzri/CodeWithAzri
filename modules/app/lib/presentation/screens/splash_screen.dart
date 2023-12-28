import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/shared.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigateToNextScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.onboardScreen, (route) => false);
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      navigateToNextScreen();
    });
    super.initState();
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
