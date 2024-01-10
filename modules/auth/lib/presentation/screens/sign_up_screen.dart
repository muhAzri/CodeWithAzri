import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:models/dto/auth/sign_up_dto.dart';
import 'package:shared/app_routes.dart';
import 'package:shared/assets_manager.dart';
import 'package:shared/flushbar_utils.dart';
import 'package:shared/styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailed) {
          FlushbarUtils.showFlushbar(context, message: state.error);
        }

        if (state is SignUpSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.mainScreen, (route) => false);
        }
      },
      child: Scaffold(
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
                  BuildHaveAccountButton(),
                  OrDividerWidget(),
                  OAuthSignInButton(
                    bloc: SignUpBloc,
                  ),
                ],
              ),
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
  final TextEditingController nameController = TextEditingController(
    text: "",
  );
  final TextEditingController emailController = TextEditingController(
    text: "",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "",
  );
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
            controller: nameController,
            prefixIconsAssets: AssetsManager.personIcon,
            hintText: "nameHintText".tr(),
          ),
          CustomTextFormField(
            controller: emailController,
            prefixIconsAssets: AssetsManager.emailIcon,
            hintText: "emailHintText".tr(),
          ),
          CustomTextFormField(
            controller: passwordController,
            prefixIconsAssets: AssetsManager.lockIcon,
            hintText: "passwordHintText".tr(),
            obscureText: isObsecured,
            onSuffixTapped: _toggleObscureText,
          ),
          BuildSignUpButton(
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}

class BuildSignUpButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const BuildSignUpButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 54.h),
      child: CustomButton(
        label: "signUpButtonLabel".tr(),
        onTap: () {
          if (nameController.text.isEmpty ||
              emailController.text.isEmpty ||
              passwordController.text.isEmpty) {
            FlushbarUtils.showFlushbar(
              context,
              message: "formsEmptyMessage".tr(),
            );
            return;
          }

          SignUpDTO dto = SignUpDTO(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          );

          context.read<SignUpBloc>().add(
                SignUpRequest(
                  dto: dto,
                ),
              );
        },
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
