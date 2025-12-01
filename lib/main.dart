import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de ejecutar código asíncrono.
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase con las opciones generadas por FlutterFire CLI.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
