import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/app_routes.dart';
import 'package:shared/assets_manager.dart';
import 'package:shared/styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                BuildSignUpHeader(),
                BuildSignUpForms(),
                BuildSignUpButton(),
                BuildHaveAccountButton(),
                OrDividerWidget(),
                OAuthSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildSignUpHeader extends StatelessWidget {
  const BuildSignUpHeader({super.key});

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
              "signUpWelcomeMessage".tr(),
              style: whiteTextStyle.copyWith(
                fontSize: 22.sp,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "signUpSubtitle".tr(),
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

class BuildSignUpForms extends StatefulWidget {
  const BuildSignUpForms({super.key});

  @override
  State<BuildSignUpForms> createState() => BuildSignUpFormsState();
}

class BuildSignUpFormsState extends State<BuildSignUpForms> {
  bool isObsecured = true;

  void _toggleObscureText() {
    setState(() {
      isObsecured = !isObsecured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 54.h,
      ),
      child: Column(
        children: [
          CustomTextFormField(
            prefixIconsAssets: AssetsManager.personIcon,
            hintText: "nameHintText".tr(),
          ),
          CustomTextFormField(
            prefixIconsAssets: AssetsManager.emailIcon,
            hintText: "emailHintText".tr(),
          ),
          CustomTextFormField(
            prefixIconsAssets: AssetsManager.lockIcon,
            hintText: "passwordHintText".tr(),
            obscureText: isObsecured,
            onSuffixTapped: _toggleObscureText,
          ),
        ],
      ),
    );
  }
}

class BuildSignUpButton extends StatelessWidget {
  const BuildSignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 54.h),
      child: CustomButton(
        label: "signUpButtonLabel".tr(),
        onTap: () {},
      ),
    );
  }
}

class BuildHaveAccountButton extends StatelessWidget {
  const BuildHaveAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "alreadyHaveAnAccountText".tr(),
            style: grayTextStyle,
          ),
          CustomTextButton(
            label: "signInButtonLabel".tr(),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.signInScreen);
            },
            labelTextStyle: whiteTextStyle,
          )
        ],
      ),
    );
  }
}
