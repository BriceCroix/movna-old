import 'package:flutter/material.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/features/home/presentation/home_page.dart';
import 'package:movna/features/ongoing_activity/presentation/ongoing_activity_page.dart';

enum RouteName {
  home,
  ongoingActivity,
}

navigateTo(RouteName route) {
  injector<GlobalKey<NavigatorState>>().currentState?.pushNamed(route.name);
}

navigateToReplacement(RouteName route) {
  injector<GlobalKey<NavigatorState>>().currentState?.pushReplacementNamed(route.name);
}

Route generateRoute(RouteSettings settings) {
  if (settings.name != null &&
      RouteName.values
          .map((e) => e.name)
          .toList()
          .contains(settings.name)) {
    switch (RouteName.values.byName(settings.name!)) {
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case RouteName.ongoingActivity:
        return MaterialPageRoute(
            builder: (context) => const OngoingActivityPage());
    }
  } else {
    // TODO error page
    return MaterialPageRoute(builder: (context) => const SizedBox());
  }
}
