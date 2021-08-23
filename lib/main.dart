import 'package:auth/src/app.dart';
import 'package:auth/src/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
    ],
    child: MyApp(),
  ));
}
