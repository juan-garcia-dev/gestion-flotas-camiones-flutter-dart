import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_camiones/providers/provider_db.dart';
import 'package:proyecto_camiones/screens/home_screen.dart';

class MiMaterialApp extends StatelessWidget {
  const MiMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class ProviderBuild extends StatelessWidget {
  const ProviderBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<ProviderDb>(create: (context) => ProviderDb())],
      child: MiMaterialApp(),
    );
  }
}
