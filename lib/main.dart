import 'package:flutter/material.dart';
import 'app.dart';
import 'core/injection.dart';

Future<void> main() async{
  configureDependencies();
  runApp(const MovnaApp());
}