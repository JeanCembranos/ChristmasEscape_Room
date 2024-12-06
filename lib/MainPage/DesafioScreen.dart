import 'dart:async';

import 'package:flutter/material.dart';

class Desafio1 extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;
  int totalSeconds;
  Timer? timer;

  Desafio1({required this.desafioIndex, required this.onComplete,required this.timer,required this.totalSeconds});


  @override
  _Desafio1State createState() => _Desafio1State();
}

class _Desafio1State extends State<Desafio1> {
  TextEditingController _hourController = TextEditingController();
  String? _selectedPeriod = 'AM'; // 'AM' o 'PM'
  String _hintText = 'Introduce la hora correcta';
  bool _isCorrect = false;
  String _currentTime = '11:00 PM'; // Hora fija (11:00 PM)

  void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("¡Hora Correcta!"),
      content: Text("¡El Reloj se ha puesto en Marcha!"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cerrar el diálogo
            // Puedes colocar aquí cualquier lógica adicional, como avanzar a la siguiente pantalla o tarea
            // Por ejemplo:
          },
          child: Text("Avanzar"),
        ),
      ],
    ),
  );
}

  void _checkAnswer() {
    // Obtener la hora ingresada y el periodo seleccionado (AM/PM)
    String hour = _hourController.text.trim();
    String selectedTime = '$hour:00 $_selectedPeriod';

    // Verificar si el widget sigue montado antes de llamar a setState
    if (!mounted) return;

    setState(() {
      // Si la respuesta es "12:00 AM" o "5:00 AM", mostramos el mensaje de éxito
      if (selectedTime == '12:00 AM' || selectedTime == '5:00 PM') {
        _hintText = '¡Respuesta correcta! El trineo comienza a volar.';
        _isCorrect = true;
      } else {
        _hintText = '¡Incorrecto! Intenta de nuevo.';
        _isCorrect = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reloj del Tiempo',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Reloj digital que muestra una hora fija
              Text(
                _currentTime, // Mostramos la hora fija 11:00 PM
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              
              SizedBox(height: 30),
              
              // Texto del acertijo
              Text(
                'En la víspera de Navidad, el tiempo se detiene.\n'
                'Suma las horas que restan para la medianoche,\n'
                'resta el número de renos de Santa,\n'
                'y marca la hora en que el trineo comienza a volar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              
              SizedBox(height: 30),
              
              // Cuadro de texto para ingresar el número de la hora
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo para ingresar la hora (número)
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _hourController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Hora',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  
                  // Etiqueta de minutos "00:00"
                  Text(
                    ':00',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  
                  // Dropdown para seleccionar AM o PM
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPeriod = newValue;
                      });
                    },
                    items: <String>['AM', 'PM'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Botón para verificar la respuesta
              ElevatedButton(
                onPressed: (){
                  _checkAnswer();
                  if(_isCorrect){
                    Navigator.pop(context);
                    widget.onComplete();
                    _showSuccessDialog();
                  }
                  
                }, 
                child: Text('Verificar Respuesta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Mensaje de estado
              Text(
                _hintText,
                style: TextStyle(
                  fontSize: 20,
                  color: _isCorrect ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}