import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
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
                BuildSignInForms(),
                BuildSignInButton(),
                BuildCreateAccountButton(),
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
              "signInWelcomeMessage".tr(),
              style: whiteTextStyle.copyWith(
                fontSize: 22.sp,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              'signInSubtitle'.tr(),
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

class BuildSignInForms extends StatefulWidget {
  const BuildSignInForms({super.key});

  @override
  State<BuildSignInForms> createState() => _BuildSignInFormsState();
}

class _BuildSignInFormsState extends State<BuildSignInForms> {
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
          SizedBox(
            height: 16.h,
          ),
          CustomTextButton(
            label: "forgotPasswordText".tr(),
            onTap: () {},
          )
        ],
      ),
    );
  }
}

class BuildSignInButton extends StatelessWidget {
  const BuildSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 54.h),
      child: CustomButton(
        label: "signInButtonLabel".tr(),
        onTap: () {},
      ),
    );
  }
}

class BuildCreateAccountButton extends StatelessWidget {
  const BuildCreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "dontHaveAnAccountText".tr(),
            style: grayTextStyle,
          ),
          CustomTextButton(
            label: "signUpButtonLabel".tr(),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.signUpScreen);
            },
            labelTextStyle: whiteTextStyle,
          )
        ],
      ),
    );
  }
}
