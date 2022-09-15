import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/router/router.dart';

class MovnaApp extends StatelessWidget {
  const MovnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movna',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: injector<GlobalKey<NavigatorState>>(),
      onGenerateRoute: generateRoute,
      initialRoute: RouteName.home.name,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green[700],
          secondary: Colors.blueAccent,
        )
      ),
    );
  }
}
