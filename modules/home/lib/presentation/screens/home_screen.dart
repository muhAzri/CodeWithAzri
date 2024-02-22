import 'package:cwa_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: const Column(
          children: [
            HomeUserInfo(),
          ],
        ),
      ),
    );
  }
}

class HomeUserInfo extends StatelessWidget {
  const HomeUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70.w,
          height: 70.w,
          decoration: const BoxDecoration(
            color: bottomNavBackgroundColor,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
          child: const Center(
            child: CircleAvatar(
              child: Text("A"),
            ),
          ),
        )
      ],
    );
  }
}
