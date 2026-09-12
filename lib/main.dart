import 'package:elcinorch/app/dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await AppDependencies.notificationService.init();

  await AppDependencies.notificationService.dailyJournalReminder();

  runApp(const Elcinorhc());
}