import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/app.dart';
import 'package:taskoteladmin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    throw Exception("Failed to initialize Firebase: $e");
    // You might want to show an error screen here
  }
  runApp(const MyApp());
}
