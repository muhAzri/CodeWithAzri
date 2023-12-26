import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/shared.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final double? height;
  final double? width;
  final TextStyle? labelTextStyle;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  const CustomButton({
    super.key,
    required this.label,
    this.height,
    this.width,
    this.labelTextStyle,
    required this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height ?? 52.h,
          width: width ?? 345.w,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Center(
            child: Text(
              label,
              style: labelTextStyle ??
                  whiteTextStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: semiBold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
