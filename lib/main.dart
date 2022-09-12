import 'package:flutter/material.dart';
import 'app.dart';
import 'core/injection.dart';

Future<void> main() async{
  setUpInjector();
  runApp(const MovnaApp());
}