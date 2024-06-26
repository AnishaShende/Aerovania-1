import 'package:aerovania_app_1/Pages/splash_screen.dart';
import 'package:aerovania_app_1/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

final authServicesProvider =
    riverpod.Provider<AuthServices>((ref) => AuthServices());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // comment this while using storage_services
  await FirebaseAppCheck.instance.activate();

  runApp(
    riverpod.ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aerovania',
      home: SplashScreen(),
    );
  }
}
