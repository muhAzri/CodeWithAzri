import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/shared.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 25.w,
            ),
            child: const Column(
              children: [
                BuildSignInHeader(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildSignInHeader extends StatelessWidget {
  const BuildSignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 78.h,
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              AssetsManager.logo,
              width: 64.w,
              height: 64.h,
              package: 'shared',
            ),
            SizedBox(
              height: 17.h,
            ),
            Text(
              "Welcome Back!",
              style: whiteTextStyle.copyWith(
                fontSize: 22.sp,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "Sign In to your account",
              style: grayTextStyle.copyWith(
                fontSize: 18.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
