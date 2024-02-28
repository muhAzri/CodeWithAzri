import 'package:auth/auth.dart';
import 'package:auth/data/enum/auth_type_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OAuthSignInButton extends StatelessWidget {
  final AuthType type;

  const OAuthSignInButton({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return AppleSignInButton(
        padding: EdgeInsets.only(top: 30.h),
      );
    }

    return GoogleSignInButton(
      type: type,
      padding: EdgeInsets.only(top: 30.h),
    );
  }
}
