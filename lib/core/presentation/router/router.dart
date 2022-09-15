import 'package:flutter/material.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/features/home/presentation/home_page.dart';
import 'package:movna/features/ongoing_activity/presentation/ongoing_activity_page.dart';
import 'package:movna/features/past_activity/presentation/past_activity_page.dart';

enum RouteName {
  home,
  ongoingActivity,
  pastActivity,
}

navigateTo(RouteName route, [Object? arguments]) {
  injector<GlobalKey<NavigatorState>>().currentState?.pushNamed(route.name, arguments: arguments);
}

navigateToReplacement(RouteName route, [Object? arguments]) {
  injector<GlobalKey<NavigatorState>>().currentState?.pushReplacementNamed(route.name, arguments: arguments);
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
      case RouteName.pastActivity:
        if(settings.arguments != null && settings.arguments is Activity) {
          final Activity activity = settings.arguments! as Activity;
          return MaterialPageRoute(
            builder: (context) => PastActivityPage(activity: activity));
        }
    }
  }
  //TODO error page
  return MaterialPageRoute(builder: (context) => const SizedBox());
}
