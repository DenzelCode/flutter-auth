import 'package:auth/src/app.dart';
import 'package:auth/src/features/notification/logic/repository/notification_repository.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await notificationRepository.setup();

  runApp(MyApp());
}
