import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:payment_getway/core/app_config.dart';
import 'package:payment_getway/core/app_providers.dart';
import 'package:payment_getway/screens/users/models/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.instance.load();

  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeUsers();
  await Firebase.initializeApp();
  runApp(const AppProviders());
}