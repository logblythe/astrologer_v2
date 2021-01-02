import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class NavigationService {
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

   goBack() {
    return navigatorKey.currentState.pop();
  }
}
