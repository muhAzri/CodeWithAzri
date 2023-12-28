import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/styles.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 4.h),
            child: const Divider(
              color: grayColor,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 34.w,
              color: backgroundColor,
              child: Center(
                child: Text(
                  'OR',
                  style: grayTextStyle.copyWith(fontSize: 16.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
