import 'package:cwa_core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: const Column(
          children: [
            HomeUserInfo(),
            HomeSearchFormField(),
            HomeContinueLessonSection(),
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
    return const Row(
      children: [
        Expanded(
          child: Row(
            children: [
              HomeUserAvatar(),
              HomeUserName(),
            ],
          ),
        ),
        HomeNotificationButton()
      ],
    );
  }
}

class HomeUserAvatar extends StatelessWidget {
  const HomeUserAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Center(
        child: Image.network(
          "https://ui-avatars.com/api/?rounded=true&name=AlqowyShaynaXo&background=EADDFF&color=21005D&size=256",
          width: 54.w,
          height: 54.h,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: 54.w,
              color: const Color(0XFFEADDFF),
            );
          },
        ),
      ),
    );
  }
}

class HomeUserName extends StatelessWidget {
  const HomeUserName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(
        left: 12.w,
      ),
      child: Text(
        "Alqowy Shayna Xo",
        style: whiteTextStyle.copyWith(
          fontWeight: semiBold,
          fontSize: 18.sp,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class HomeNotificationButton extends StatelessWidget {
  final bool isHaveNotification;

  const HomeNotificationButton({
    super.key,
    this.isHaveNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 55.w,
        height: 55.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: bottomNavBackgroundColor,
        ),
        child: Center(
          child: SizedBox(
            width: 24.w,
            height: 24.w,
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: whiteColor,
                  size: 24.sp,
                ),
                if (isHaveNotification)
                  Positioned(
                    top: 3.h,
                    right: 3.w,
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSearchFormField extends StatelessWidget {
  const HomeSearchFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.h),
      child: TextFormField(
        cursorColor: whiteColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: whiteColor,
            size: 24.sp,
          ),
          hintText: "searchBarPlaceholderText".tr(),
          hintStyle: grayTextStyle.copyWith(fontSize: 16.sp),
          isCollapsed: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: bottomNavBackgroundColor,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 20.w,
          ),
        ),
      ),
    );
  }
}

class HomeContinueLessonSection extends StatelessWidget {
  const HomeContinueLessonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "homeContinueLearningText".tr(),
            style: whiteTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Container(
            width: 345.w,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            decoration: BoxDecoration(
              color: bottomNavBackgroundColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 190.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mastering Figma Auto Layout",
                            maxLines: 2,
                            style: whiteTextStyle.copyWith(
                              fontSize: 20.sp,
                              fontWeight: bold,
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Text(
                            "UI/UX Design",
                            style: grayTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: AssetImage(
                            AssetsManager.dummyCourseImage,
                            package: "cwa_core",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                LinearPercentIndicator(
                  barRadius: Radius.circular(100.r),
                  width: 260.w,
                  padding: EdgeInsets.zero,
                  percent: 11 / 69,
                  lineHeight: 8.h,
                  progressColor: primaryColor,
                  backgroundColor: grayColor,
                  trailing: Container(
                    margin: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "11/69",
                      style: whiteTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
