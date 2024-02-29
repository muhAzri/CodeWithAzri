import 'package:flutter/material.dart';

String getAvatarUrl(String name) {
  return "https://ui-avatars.com/api/?rounded=true&name=$name&background=EADDFF&color=21005D&size=256";
}

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();
