import 'dart:async';
import 'package:christmas_project/MainPage/Desafio2Screen.dart';
import 'package:christmas_project/MainPage/DesafioCaminoQR.dart';
import 'package:christmas_project/MainPage/DesafioCofreCerrado.dart';
import 'package:christmas_project/MainPage/DesafioLockScreen.dart';
import 'package:christmas_project/MainPage/DesafioOSI.dart';
import 'package:christmas_project/MainPage/DesafioSQL.dart';
import 'package:christmas_project/MainPage/DesafioScreen.dart';
import 'package:christmas_project/main.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _totalSeconds = 3600; // 1 hora = 3600 segundos
  bool _isTimeUp = false; // Para saber si el tiempo se agotó
  Timer? _timer; // Declaramos el Timer
  List<bool> desafios = List.generate(10, (index) => index == 0);
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  @override
  void dispose() {
    _timer?.cancel(); // Detener el temporizador cuando el widget se destruya
    super.dispose();
  }

  void completarDesafio(int index) {
    setState(() {
      if (index < desafios.length - 1) {
        desafios[index + 1] = true;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_totalSeconds > 0 && !_isTimeUp) {
        setState(() {
          _totalSeconds--;
        });
      } else if (!_isTimeUp) {
        _timer?.cancel(); // Detener el temporizador cuando llegue a 0
        setState(() {
          _isTimeUp = true; // Indicar que el tiempo se agotó
        });
        _showTimeUpDialog(); // Mostrar un diálogo de "Tiempo agotado"
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¡Tiempo Agotado!"),
        content: Text("El tiempo ha terminado. La app está bloqueada."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  String formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Desafío Navideño', style: TextStyle(color: Colors.white)),
            // Contenedor que cambia de color según el estado del temporizador
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isTimeUp ? Colors.red : Colors.green, // Rojo si el tiempo se agotó, verde si no
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                formatTime(_totalSeconds),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos columnas para las tarjetas
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/home_screen/Icono_regalo.png'),
                      fit: BoxFit.cover, // Ajusta la imagen para cubrir toda el área del container
                    ),
                  ),
                  child: InkWell(
                    onTap: desafios[index]
                        ? () {
                          switch (index){
                            
                            case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LockScreen(
                                   desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                  totalSeconds: _totalSeconds,
                                  timer: _timer,
                                ),
                              ),
                            );



                           /* case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioOSI(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                  totalSeconds: _totalSeconds,
                                  timer: _timer,
                                ),
                              ),
                            );*/
                            case 1:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Desafio1(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                  totalSeconds: _totalSeconds,
                                  timer: _timer,
                                ),
                              ),
                            );
                            case 2:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Desafio2Screen(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                  totalSeconds: _totalSeconds,
                                  timer: _timer,
                                ),
                              ),
                            );
                            case 3:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioCofreCerrado(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                  totalSeconds: _totalSeconds,
                                  timer: _timer,
                                ),
                              ),
                            );
                            case 4:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioCaminoQR(
                                 desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                  totalSeconds: _totalSeconds,
                                  timer: _timer,
                                ),
                              ),
                            ); 
                            case 5:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioSQL(
                                 desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                  totalSeconds: _totalSeconds,
                                  timer: _timer,
                                ),
                              ),
                            ); 
                          }
                          }
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: desafios[index] ? Colors.green : Colors.grey,
                          ),
                          child: desafios[index]
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 40,
                                )
                              : null,
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(3),
                          child: Text(
                            'Desafío ${index + 1}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
  }
}