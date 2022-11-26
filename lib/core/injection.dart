import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:movna/core/data/models/activity_model.dart';
import 'package:movna/core/data/models/gear_model.dart';
import 'package:movna/core/data/models/itinerary_model.dart';
import 'package:path_provider/path_provider.dart';
import 'injection.config.dart';

final injector = GetIt.instance;
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

@InjectableInit()
GetIt _configureDependencies() => $initGetIt(injector);

Future<Isar> _openIsar() async {
  Directory dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    schemas: [ActivityModelSchema, GearModelSchema, ItineraryModelSchema],
    directory: dir.path,
  );
}

void setUpInjector() async {
  _configureDependencies();
  injector.registerSingleton<GlobalKey<NavigatorState>>(_navigatorKey);
  injector.registerLazySingletonAsync<Isar>(
    () async => await _openIsar(),
    dispose: (isar) => isar.close(),
  );
}
