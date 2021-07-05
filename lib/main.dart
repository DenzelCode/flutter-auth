import 'package:auth/src/app.dart';
import 'package:auth/src/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<AuthService>(AuthService());

  runApp(MyApp());
}
