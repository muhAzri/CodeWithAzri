import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:auth/bloc/auth/auth_bloc.dart';
import 'package:auth/data/enum/auth_type_enum.dart';
import 'package:cwa_core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignInFailed) {
          context.loaderOverlay.hide();
          FlushbarUtils.showFlushbar(context, message: state.error);
        }

        if (state is ForgotPasswordFailed) {
          context.loaderOverlay.hide();
          FlushbarUtils.showFlushbar(context, message: state.error);
        }

        if (state is ForgotPasswordSuccess) {
          context.loaderOverlay.hide();
          FlushbarUtils.showFlushbar(
            context,
            message: "resetPasswordSended".tr(),
            color: Colors.green,
          );
        }

        if (state is SignInSuccess) {
          context.loaderOverlay.hide();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.mainScreen, (route) => false);
        }

        if (state is SignInLoading || state is ForgotPasswordLoading) {
          context.loaderOverlay.hide();
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
                  BuildSignInHeader(),
                  BuildSignInForms(),
                  BuildCreateAccountButton(),
                  OrDividerWidget(),
                  OAuthSignInButton(
                    type: AuthType.signIn,
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
              package: 'cwa_core',
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
  const BuildSignInForms({
    super.key,
  });

  @override
  State<BuildSignInForms> createState() => BuildSignInFormsState();
}

class BuildSignInFormsState extends State<BuildSignInForms> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

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
          SizedBox(
            height: 16.h,
          ),
          CustomTextButton(
            label: "forgotPasswordText".tr(),
            onTap: () {
              if (emailController.text.isNotEmpty) {
                context
                    .read<AuthBloc>()
                    .add(ForgotPasswordRequest(email: emailController.text));
              } else {
                FlushbarUtils.showFlushbar(
                  context,
                  message: "Please ${"emailHintText".tr()}",
                );
              }
            },
          ),
          BuildSignInButton(
            emailController: emailController,
            passwordController: passwordController,
          )
        ],
      ),
    );
  }
}

class BuildSignInButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const BuildSignInButton(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 54.h),
      child: CustomButton(
        label: "signInButtonLabel".tr(),
        onTap: () {
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            context.read<AuthBloc>().add(SignInRequest(
                signInDTO: SignInDTO(
                    email: emailController.text,
                    password: passwordController.text)));
          } else {
            FlushbarUtils.showFlushbar(context,
                message: "formsEmptyMessage".tr());
          }
        },
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
