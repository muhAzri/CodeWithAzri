import 'package:cwa_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String prefixIconsAssets;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final VoidCallback? onSuffixTapped;

  const CustomTextFormField({
    super.key,
    required this.prefixIconsAssets,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.onSuffixTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: grayColor,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildPrefix(),
          _buildTextFormField(),
          onSuffixTapped != null ? _buildObsecureCanceler() : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildPrefix() {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      child: Image.asset(
        prefixIconsAssets,
        width: 24.w,
        height: 24.h,
        color: grayColor,
        package: 'cwa_core',
      ),
    );
  }

  Widget _buildTextFormField() {
    return Expanded(
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: whiteTextStyle.copyWith(
          fontWeight: medium,
        ),
        decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: grayTextStyle.copyWith(
            fontWeight: light,
          ),
        ),
      ),
    );
  }

  Widget _buildObsecureCanceler() {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      child: InkWell(
        onTap: onSuffixTapped,
        child: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: grayColor,
          size: 24.w,
        ),
      ),
    );
  }
}
