import 'dart:async';

import 'package:flutter/material.dart';

class LockScreen extends StatefulWidget {

  final int desafioIndex;
  final VoidCallback onComplete;
  int totalSeconds;
  Timer? timer;

  LockScreen({required this.desafioIndex, required this.onComplete,required this.timer,required this.totalSeconds});


  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  // Controladores para los TextFields
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  // FocusNodes para manejar el enfoque del cursor
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  // Lista para almacenar las pistas generadas
  List<String> _hints = [];

  // Código correcto
  final String _correctCode = "2597";

  // Función para verificar el código
  void _checkCode() {
    String enteredCode = _controller1.text + _controller2.text + _controller3.text + _controller4.text;

    // Limpiar las pistas anteriores antes de agregar una nueva
    setState(() {
      _hints.clear();
    });

    // Verificar si el código ingresado es correcto
    if (enteredCode == _correctCode) {
      setState(() {
        widget.onComplete();
        Navigator.pop(context);
        _hints.add("¡Código correcto! Has desbloqueado el candado.");
      });
    } else {
      setState(() {
        _hints.add(_generateHint(enteredCode));
      });
    }
  }

  /*// Función para generar pistas basadas en el código ingresado
  String _generateHint(String enteredCode) {
    int correctCount = 0;
    int misplacedCount = 0;
    int incorrectCount = 0;

    for (int i = 0; i < enteredCode.length; i++) {
      if (enteredCode[i] == _correctCode[i]) {
        correctCount++;
      } else if (_correctCode.contains(enteredCode[i])) {
        misplacedCount++;
      } else {
        incorrectCount++;
      }
    }

    // Crear el mensaje genérico
    String hint = '';
    if (correctCount > 0) {
      hint += "$correctCount números correctos, ";
    }
    if (misplacedCount > 0) {
      hint += "$misplacedCount números correctos pero en posición incorrecta, ";
    }
    if (incorrectCount > 0) {
      hint += "$incorrectCount números incorrectos.";
    }

    return hint;
  }*/

// Función para generar pistas basadas en el código ingresado
String _generateHint(String enteredCode) {
  int correctCount = 0;
  int misplacedCount = 0;
  int incorrectCount = 0;

  // Listas para hacer seguimiento de los números ya procesados
  List<bool> countedAsCorrect = List.filled(enteredCode.length, false);
  List<bool> countedAsMisplaced = List.filled(enteredCode.length, false);
  List<bool> countedInCorrectCode = List.filled(_correctCode.length, false);

  // Primero, verificamos los números correctos en su lugar
  for (int i = 0; i < enteredCode.length; i++) {
    if (enteredCode[i] == _correctCode[i]) {
      correctCount++;
      countedAsCorrect[i] = true; // Marcar como ya contado
      countedInCorrectCode[i] = true; // Marca la posición correcta ya validada
    }
  }

  // Ahora verificamos los números en posición incorrecta
  for (int i = 0; i < enteredCode.length; i++) {
    if (enteredCode[i] != _correctCode[i] && _correctCode.contains(enteredCode[i])) {
      // Buscar el número en el código correcto, pero solo si no ha sido contado como correcto
      for (int j = 0; j < _correctCode.length; j++) {
        if (_correctCode[j] == enteredCode[i] && !countedInCorrectCode[j] && !countedAsMisplaced[j]) {
          misplacedCount++;
          countedAsMisplaced[i] = true; // Marcar como ya contado como "en posición incorrecta"
          countedInCorrectCode[j] = true; // Marcar la posición correcta ya validada
          break; // Salir del ciclo una vez que se cuente el número en la posición incorrecta
        }
      }
    }
  }

  // Finalmente, contamos los números incorrectos
  for (int i = 0; i < enteredCode.length; i++) {
    if (!countedAsCorrect[i] && !countedAsMisplaced[i]) {
      incorrectCount++;
    }
  }

  // Crear el mensaje genérico
  String hint = '';
  if (correctCount > 0) {
    hint += "$correctCount número(s) correcto(s), ";
  }
  if (misplacedCount > 0) {
    hint += "$misplacedCount número(s) correcto(s) pero en posición incorrecta, ";
  }
  if (incorrectCount > 0) {
    hint += "$incorrectCount número(s) incorrecto(s).";
  }

  return hint;
}
  @override
  void dispose() {
    // Limpiar los FocusNodes cuando ya no se usen
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  // Widget para crear los TextFields
  Widget _buildTextField(TextEditingController controller, FocusNode focusNode, FocusNode nextFocusNode) {
    return Container(
      width: 50,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center, // Centra el texto dentro del TextField
        style: TextStyle(
          fontSize: 25, // Aumenta el tamaño de la fuente
          fontWeight: FontWeight.bold, // Opcional: hace el texto más negrita
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true, // Habilita el fondo
          fillColor: Colors.white, // Establece el color de fondo blanco
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Si se ingresa un número, pasa al siguiente campo automáticamente
          if (value.isNotEmpty) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Desafío del Candado", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Usamos un Stack para colocar los TextFields sobre la imagen del candado
              Stack(
                alignment: Alignment.center,
                children: [
                  // Imagen del candado
                  Container(
                    width: 350,  // Tamaño ajustado del candado
                    height: 350,  // Tamaño ajustado del candado
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/desafio_screen/candado.png'), // Asegúrate de agregar una imagen llamada "candado.png" en tu carpeta assets
                        fit: BoxFit.contain, // Ajusta la imagen de manera que quede bien en el contenedor sin estirarse
                      ),
                    ),
                  ),
                  // Los 4 TextFields dentro del candado
                  Positioned(
                    top: 250,  // Ubicación vertical ajustada para los TextFields
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTextField(_controller1, _focusNode1, _focusNode2),
                        SizedBox(width: 10),
                        _buildTextField(_controller2, _focusNode2, _focusNode3),
                        SizedBox(width: 10),
                        _buildTextField(_controller3, _focusNode3, _focusNode4),
                        SizedBox(width: 10),
                        _buildTextField(_controller4, _focusNode4, _focusNode4), // El último campo no tiene siguiente
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30), // Espacio entre los TextFields y las pistas

              // Mostrar las pistas generadas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _hints.map((hint) => Text(hint, style: TextStyle(fontSize: 16, color: Colors.black))).toList(),
              ),
              SizedBox(height: 20),

              // Botón para enviar el intento
              ElevatedButton(
                onPressed: _checkCode,
                child: Text("Enviar Intento", style: TextStyle(fontSize: 18,color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.green, // Color verde para el botón
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}