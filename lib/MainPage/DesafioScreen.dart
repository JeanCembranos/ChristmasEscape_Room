import 'dart:async';

import 'package:flutter/material.dart';

class DesafioScreen extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;
  int totalSeconds;
  Timer? timer;

  DesafioScreen({required this.desafioIndex, required this.onComplete,required this.timer,required this.totalSeconds});

  @override
  _DesafioScreenState createState() => _DesafioScreenState();
}
class _DesafioScreenState extends State<DesafioScreen> {
  int _expandedTileIndex = -1;  // -1 significa que ninguno está expandido inicialmente
   bool _showFloatingButton = false;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
    void dispose() {
      super.dispose();
    }
    
  @override
  Widget build(BuildContext context) {    
      return Scaffold(
        appBar: AppBar(
        title: Text('Desafío Navideño',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
        actions: [
          // Temporizador en el AppBar con horas, minutos y segundos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.timer), // Icono de temporizador
                SizedBox(width: 5),
                
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
         Text(
              '¡Resuelve este desafío!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller, // Vincula el controlador
              decoration: InputDecoration(
                labelText: 'Ingresa el código secreto',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String input = _controller.text;
                 if (input == "desafio1") {
                      widget.onComplete();
                      Navigator.pop(context);
                    }
              },
              child: Text('Resolver Desafío'),
            ),
          ],
        ),
      )
      );
  }
}