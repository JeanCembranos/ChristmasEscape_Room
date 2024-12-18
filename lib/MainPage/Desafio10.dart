import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FelicitacionScreen extends StatefulWidget {

  int totalSeconds = 0;

  FelicitacionScreen({required this.totalSeconds});
  @override
  _FelicitacionScreenState createState() => _FelicitacionScreenState();
}

class _FelicitacionScreenState extends State<FelicitacionScreen> {
  bool _animating = false; // Para controlar si la animación está en curso

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  // Método para simular la animación de Santa volando
  void _startAnimation() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _animating = true; // Inicia la animación después de 2 segundos
      });
    });
  }

  String formatTime(int totalSeconds) {
    int timeElapsed = 3600 - totalSeconds;
    int hours = timeElapsed ~/ 3600;
    int minutes = (timeElapsed % 3600) ~/ 60;
    int seconds = timeElapsed % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('La Misión de Santa'),
        backgroundColor: Colors.green,
      ),
      body: PopScope(
        canPop: false,
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Felicidades, el Espíritu Navideño ha sido recuperado!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Gracias a tu valentía, la Navidad ha sido salvada.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Imagen GIF de Santa volando (Aquí puedes poner el archivo local o de red)
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: _animating
                  ? Container(
                      width: 200,
                      height: 200,
                      child: Image.asset('assets/images/desafio_screen/christmas.gif'),  // Cambia el path según tu archivo
                    )
                  : CircularProgressIndicator(), // Mostrar un loading antes de la animación
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            // Contenedor con el tiempo y los desafíos completados
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Tiempo Total: ' +formatTime(widget.totalSeconds),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Desafíos Completados: 10/10',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      )
      
    );
  }
}