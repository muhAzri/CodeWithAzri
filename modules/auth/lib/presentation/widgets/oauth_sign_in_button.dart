import 'package:auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
