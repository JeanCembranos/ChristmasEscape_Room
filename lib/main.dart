import 'dart:async';

import 'package:christmas_project/MainPage/DesafioCofreCerrado.dart';
import 'package:christmas_project/MainPage/MainPage.dart';
import 'package:christmas_project/Splash_Tools/Splash_Screen.dart';
import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerService()), // Aseguramos que TimerService esté disponible globalmente
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación del Temporizador',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), // Página principal
    );
  }
}