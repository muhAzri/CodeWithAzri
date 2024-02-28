import 'package:auth/bloc/auth/auth_bloc.dart';
import 'package:auth/data/enum/auth_type_enum.dart';
import 'package:cwa_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleSignInButton extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final AuthType type;
  const GoogleSignInButton(
      {super.key, this.padding, this.margin, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: InkWell(
        onTap: () {
          if (type == AuthType.signIn) {
            context.read<AuthBloc>().add(SignInByGoogleRequest());
          }
          if (type == AuthType.signUp) {
            context.read<AuthBloc>().add(SignUpByGoogleRequest());
          }
        },
        child: Image.asset(
          AssetsManager.loginGoogle,
          width: 274.w,
          package: 'cwa_core',
        ),
      ),
    );
  }
}
