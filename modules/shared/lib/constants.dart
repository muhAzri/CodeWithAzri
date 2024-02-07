import 'package:flutter/material.dart';

String getAvatarUrl(String name) {
  return "https://ui-avatars.com/api/?rounded=true&name=$name";
}

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();
