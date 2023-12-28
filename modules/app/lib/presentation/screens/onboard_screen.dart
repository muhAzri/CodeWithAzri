import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/shared.dart';
import 'package:app/presentation/widgets/custom_button.dart';
import 'package:app/presentation/widgets/custom_text_button.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardLogo(),
              TagLine(),
              DescriptionSection(),
              CreateNewAccountButton(),
              GoToSignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardLogo extends StatelessWidget {
  const OnboardLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.h),
      child: Image.asset(
        AssetsManager.onboard,
        width: 342.w,
        height: 280.h,
      ),
    );
  }
}

class TagLine extends StatelessWidget {
  const TagLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.h, left: 24.w, right: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Learn.",
            style: whiteTextStyle.copyWith(
              fontSize: 66.sp,
              fontWeight: black,
              height: 0.8.h,
            ),
          ),
          Text(
            "Practice.",
            style: purpleTextStyle.copyWith(
              fontSize: 66.sp,
              fontWeight: black,
              height: 0.8.h,
            ),
          ),
          Text(
            "Earn.",
            style: whiteTextStyle.copyWith(
              fontSize: 66.sp,
              fontWeight: black,
              height: 0.8.h,
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.h, left: 24.w, right: 24.w),
      child: Text(
        "New way to study abroad from the real professional with great work.",
        style: grayTextStyle.copyWith(
          fontSize: 16.sp,
        ),
      ),
    );
  }
}

class CreateNewAccountButton extends StatelessWidget {
  const CreateNewAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Create New Account',
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.signUpScreen);
      },
      padding: EdgeInsets.only(
        top: 40.h,
        bottom: 30.h,
        left: 24.h,
        right: 24.w,
      ),
    );
  }
}

class GoToSignInButton extends StatelessWidget {
  const GoToSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomTextButton(
        label: 'Sign In to My Account',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.signInScreen);
        },
      ),
    );
  }
}
