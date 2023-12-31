import 'package:auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OAuthSignInButton extends StatelessWidget {
  final Type? bloc;
  const OAuthSignInButton({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return AppleSignInButton(
        padding: EdgeInsets.only(top: 30.h),
      );
    }

    return GoogleSignInButton(
      bloc: bloc,
      padding: EdgeInsets.only(top: 30.h),
    );
  }
}
