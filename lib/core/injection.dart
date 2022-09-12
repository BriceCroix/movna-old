import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final injector = GetIt.instance;
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

@InjectableInit()
GetIt _configureDependencies() => $initGetIt(injector);

void setUpInjector() {
  _configureDependencies();
  injector.registerSingleton<GlobalKey<NavigatorState>>(_navigatorKey);
}
