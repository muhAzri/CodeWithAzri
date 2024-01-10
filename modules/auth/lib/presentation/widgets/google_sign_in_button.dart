import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/assets_manager.dart';

class GoogleSignInButton extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Type? bloc;
  const GoogleSignInButton({super.key, this.padding, this.margin, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: InkWell(
        onTap: () {
          if (bloc == SignInBloc) {
            context.read<SignInBloc>().add(SignInByGoogleRequest());
          }
          if (bloc == SignUpBloc) {
            context.read<SignUpBloc>().add(SignUpByGoogleRequest());
          }
        },
        child: Image.asset(
          AssetsManager.loginGoogle,
          width: 274.w,
          package: 'shared',
        ),
      ),
    );
  }
}
