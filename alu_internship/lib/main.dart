// App entry point: initializes Firebase and wraps the app in a Riverpod ProviderScope.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async{
await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(());
}
