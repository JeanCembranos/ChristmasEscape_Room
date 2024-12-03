import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? actions;

  BaseScreen({required this.child, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        //actions: actions, // Puedes agregar botones o el contador aquí
      ),
      body: child, // El contenido de la pantalla se pasa como 'child'
    );
  }
}