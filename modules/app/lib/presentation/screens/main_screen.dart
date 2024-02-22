import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home/presentation/screens/home_screen.dart';
import 'package:shared/shared.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildHomeScreen() {
    return const HomeScreen();
  }

  Widget _buildSearchScreen() {
    return const Center(
      child: Text("Search Screen"),
    );
  }

  Widget _buildMyCourseScreen() {
    return const Center(
      child: Text("My Course Screen"),
    );
  }

  Widget _buildProfileScreen() {
    return const Center(
      child: Text("Profile Screen"),
    );
  }

  Widget? _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return _buildSearchScreen();
      case 2:
        return _buildMyCourseScreen();
      case 3:
        return _buildProfileScreen();
    }
    return null;
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: whiteColor,
      unselectedItemColor: grayColor,
      backgroundColor: bottomNavBackgroundColor,
      currentIndex: _currentIndex,
      onTap: _setIndex,
      items: _bottomNavigationBarItems(),
    );
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Container(
          padding: EdgeInsets.only(top: 6.h),
          child: const Icon(
            Icons.home_rounded,
          ),
        ),
        label: 'navBarItemHome'.tr(),
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: EdgeInsets.only(top: 6.h),
          child: const Icon(
            Icons.explore_outlined,
          ),
        ),
        label: 'navBarItemSearch'.tr(),
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: EdgeInsets.only(top: 6.h),
          child: const Icon(
            Icons.menu_book_outlined,
          ),
        ),
        label: 'navBarItemMyCourse'.tr(),
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: EdgeInsets.only(top: 6.h),
          child: const Icon(
            Icons.person_outline,
          ),
        ),
        label: 'navBarItemProfile'.tr(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: buildBottomNavigationBar(),
      body: _buildBody(),
    );
  }
}
