import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/assets_manager.dart';

class AppleSignInButton extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const AppleSignInButton({super.key, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: InkWell(
        onTap: () {},
        child: Image.asset(
          AssetsManager.loginApple,
          width: 342.w,
        ),
      ),
    );
  }
}
