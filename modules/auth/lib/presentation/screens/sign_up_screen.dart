import 'package:app/app.dart';
import 'package:auth/presentation/widgets/apple_sign_in_button.dart';
import 'package:auth/presentation/widgets/google_sign_in_button.dart';
import 'package:auth/presentation/widgets/or_divider_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              "Hello Fam 👋",
              style: whiteTextStyle.copyWith(
                fontSize: 22.sp,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "Create your account & enjoy",
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
  State<BuildSignUpForms> createState() => _BuildSignUpFormsState();
}

class _BuildSignUpFormsState extends State<BuildSignUpForms> {
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
            hintText: "Type Your Name",
          ),
          CustomTextFormField(
            prefixIconsAssets: AssetsManager.emailIcon,
            hintText: "Type Your Email",
          ),
          CustomTextFormField(
            prefixIconsAssets: AssetsManager.lockIcon,
            hintText: "Type Your Password",
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
        label: "Sign Up",
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
            "Already have an account? ",
            style: grayTextStyle,
          ),
          CustomTextButton(
            label: "Sign In",
            onTap: () {},
            labelTextStyle: whiteTextStyle,
          )
        ],
      ),
    );
  }
}

class OAuthSignInButton extends StatelessWidget {
  const OAuthSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return AppleSignInButton(
        padding: EdgeInsets.only(top: 30.h),
      );
    }

    return GoogleSignInButton(
      padding: EdgeInsets.only(top: 30.h),
    );
  }
}
