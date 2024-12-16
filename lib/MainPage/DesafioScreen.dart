import 'dart:async';

import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Desafio1 extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;

  Desafio1({required this.desafioIndex, required this.onComplete});


  @override
  _Desafio1State createState() => _Desafio1State();
}

class _Desafio1State extends State<Desafio1> {
  TextEditingController _controllerUserBypass = TextEditingController();
  TextEditingController _controllerPassBypass = TextEditingController();
  TextEditingController _hourController = TextEditingController();
  String? _selectedPeriod = 'AM'; // 'AM' o 'PM'
  String _hintText = 'Introduce la hora correcta';
  bool _isCorrect = false;
  String _currentTime = '11:00 PM'; // Hora fija (11:00 PM)
  bool _isTimeUp = false; // Para saber si el tiempo se agotó

  void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("¡Hora Correcta!"),
      content: Text("¡El Reloj se ha puesto en Marcha nuevamente y Santa podrá entregar los regalos a tiempo!!"),
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
      if (selectedTime == '4:00 PM') {
        _isCorrect = true;
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrecto. Analízalo e intenta nuevamente.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2), // Duración de 5 segundos
        ),
    );
        _isCorrect = false;
      }
    });
  }

  // Función para mostrar el formulario de login
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uso solo para ADMINS'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controllerUserBypass,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _controllerPassBypass,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if(_controllerUserBypass.text == 'admin' && _controllerPassBypass.text == 'd3n1g2r1rd3n1'){
                  widget.onComplete();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Credenciales Erróneas. No se ha podido marcar como completado'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 5), // Duración de 5 segundos
                  ),
                );
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);
    if (timerService.isTimeUp && !_isTimeUp) {
    // Diferir la ejecución de la lógica usando addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Actualizar el estado y cerrar la pantalla
      setState(() {
        _isTimeUp = true; // Marcar que el tiempo se agotó
      });

      // Cerrar la pantalla
      Navigator.pop(context);  // Esto cerrará la pantalla
    });
  }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red, // Fondo rojo
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Título
              Text(
                "Desafio 8",
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              // Espaciado flexible entre el título y el contador
              Expanded(
                child: Container(), // Expande el espacio restante para evitar que el contador se pegue al borde
              ),
              // Contador
              GestureDetector(
              onTap: (){
                 _showLoginDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: timerService.isTimeUp ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timerService.formatTime(timerService.totalSeconds),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ],
          ),
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
                'Suma las horas que faltan para que todo comience,\n'
                'Resta el número de seres que impulsan el viaje nocturno a través de los cielos\n'
                'Y reduce de la hora en que este comienza a volar.',
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
              
              SizedBox(height: 80),
              
              // Botón para verificar la respuesta
              ElevatedButton(
                onPressed: () {
                  _checkAnswer();
                  if (_isCorrect) {
                    Navigator.pop(context);
                    widget.onComplete();
                    _showSuccessDialog();
                  }
                },
                child: Text(
                  'Verificar Respuesta',
                  style: TextStyle(
                    color: Colors.white, // Color del texto en blanco
                    fontSize: 18, // Aumentar el tamaño del texto
                    fontWeight: FontWeight.bold, // Hacer el texto en negrita
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Color de fondo más atractivo
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Aumentar el tamaño del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Bordes redondeados para un estilo más suave
                  ),
                  elevation: 5, // Agregar sombra para darle más profundidad
                ),
              ),
              
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}