import 'package:flutter/material.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/features/gear_management/presentation/widgets/gear_list_page.dart';
import 'package:movna/features/gear_management/presentation/widgets/user_gear_page.dart';
import 'package:movna/features/home/presentation/widgets/home_page.dart';
import 'package:movna/features/itineraries_management/presentation/widgets/itineraries_list_page.dart';
import 'package:movna/features/itineraries_management/presentation/widgets/user_itinerary_page.dart';
import 'package:movna/features/ongoing_activity/presentation/widgets/ongoing_activity_page.dart';
import 'package:movna/features/past_activity/presentation/widgets/past_activity_page.dart';

enum RouteName {
  home,
  ongoingActivity,
  pastActivity,
  gearList,
  userGear,
  itinerariesList,
  userItinerary,
}

Future navigateTo(RouteName route, [Object? arguments]) async {
  return await injector<GlobalKey<NavigatorState>>()
      .currentState
      ?.pushNamed(route.name, arguments: arguments);
}

Future navigateToReplacement(RouteName route, [Object? arguments]) async {
  return await injector<GlobalKey<NavigatorState>>()
      .currentState
      ?.pushReplacementNamed(route.name, arguments: arguments);
}

// TODO : create a true error page
const Widget errorPage = Center(child: Text('Route error'));

Route generateRoute(RouteSettings settings) {
  if (settings.name != null &&
      RouteName.values.map((e) => e.name).toList().contains(settings.name)) {
    switch (RouteName.values.byName(settings.name!)) {
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case RouteName.ongoingActivity:
        return MaterialPageRoute(
            builder: (context) => const OngoingActivityPage());
      case RouteName.pastActivity:
        if (settings.arguments != null &&
            settings.arguments is PastActivityPageParams) {
          final params = settings.arguments! as PastActivityPageParams;
          return MaterialPageRoute(
              builder: (context) => PastActivityPage(params: params));
        }
        break;
      case RouteName.gearList:
        return MaterialPageRoute(builder: (context) => const GearListPage());
      case RouteName.userGear:
        if (settings.arguments != null &&
            settings.arguments is UserGearPageParams) {
          final pageParams = settings.arguments! as UserGearPageParams;
          return MaterialPageRoute(
              builder: (context) => UserGearPage(pageParams: pageParams));
        }
        break;
      case RouteName.itinerariesList:
        return MaterialPageRoute(
            builder: (context) => const ItinerariesListPage());
      case RouteName.userItinerary:
        if (settings.arguments != null &&
            settings.arguments is UserItineraryPageParams) {
          final pageParams = settings.arguments! as UserItineraryPageParams;
          return MaterialPageRoute(
              builder: (context) => UserItineraryPage(pageParams: pageParams));
        }
        break;
      default:
        break;
    }
  }
  return MaterialPageRoute(builder: (context) => errorPage);
}
