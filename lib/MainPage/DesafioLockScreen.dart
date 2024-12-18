import 'dart:async';

import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LockScreen extends StatefulWidget {

  final int desafioIndex;
  final VoidCallback onComplete;
  
  LockScreen({required this.desafioIndex, required this.onComplete});


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
  bool _isDialogOpen = false;
  int intentos = 0;
  bool _isTimeUp = false; // Para saber si el tiempo se agotó

  @override
  void initState() {
    super.initState();
     
      WidgetsBinding.instance.addPostFrameCallback((_) => _showChallengeDialog());
    
  }

  // Método para mostrar un cuadro de ayuda
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ayuda"),
          content: Text("Debes enviar el primer intento de código para generar nuevas pistas\n\nTomar en cuenta que mas de un campo no puede contener el mismo número"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  // Función para verificar el código
  void _checkCode() {
    String enteredCode = (_controller1.text.isEmpty ? '0' : _controller1.text) +
                     (_controller2.text.isEmpty ? '0' : _controller2.text) +
                     (_controller3.text.isEmpty ? '0' : _controller3.text) +
                     (_controller4.text.isEmpty ? '0' : _controller4.text);

    // Limpiar las pistas anteriores antes de agregar una nueva
    setState(() {
      _hints.clear();
    });
  
    // Verificar si el código ingresado es correcto
    if (enteredCode == _correctCode) {
      setState(() {
        widget.onComplete();
        Navigator.pop(context);
        _showSuccessDialog();
      });

    } else {
      // Esperar 1 segundo antes de generar las nuevas pistas
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        // Generar una nueva pista después de 1 segundo
        _hints.add(_generateHint(enteredCode)); 
        intentos++; // Aumentar el número de intentos
      });
    });
  }
    }

  void _showChallengeDialog() {
    _isDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text('¡Bienvenido al Desafío 4!'),
        content: SingleChildScrollView(  // Permite que el contenido se desplace si es largo
          child: Column(
            children: [
              Text(
                "¡Buen trabajo, elfos! Habéis logrado restaurar el flujo de información, pero la misión aún no está completa. El villano ha dejado un enigma en forma de un código que es crucial para avanzar. Cada intento os dará nuevas pistas, pero sólo la combinación correcta abrirá el camino. Recordad: no todo es lo que parece, y cada error puede acercaros un paso más a la verdad. ¡La Navidad está en juego, no perdáis tiempo!",
                style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,  // Centrar el texto para mejor apariencia
              ),
              SizedBox(height: 10),  // Espacio entre el texto y la imagen
              Image.asset(
                'assets/images/desafio_screen/codigo.gif',  // Ruta de la imagen de Papá Noel
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _isDialogOpen = false;
              Navigator.pop(context); // Cerrar el diálogo
            },
            child: Text('Entendido'),
          ),
        ],
      ),
      )
    );
  }

   void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Felicidades!!",style: TextStyle(fontSize: 30.0),),
      content: Text("¡Excelente trabajo! Habéis resuelto el misterio y recuperado una parte del Espíritu Navideño. Pero la misión aún no termina... ¡El villano sigue siendo una amenaza! Prepárense para el siguiente desafío, ¡la Navidad sigue dependiendo de vosotros! 🎅🎄",style: TextStyle(fontSize: 20.0),),
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

String _generateHint(String enteredCode) {
  int correctCount = 0;
  int misplacedCount = 0;
  int incorrectCount = 0;

  // Listas para hacer seguimiento de los números ya procesados
  List<bool> countedAsCorrect = List.filled(enteredCode.length, false);
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
        if (_correctCode[j] == enteredCode[i] && !countedInCorrectCode[j] && !countedAsCorrect[i]) {
          misplacedCount++;
          countedInCorrectCode[j] = true; // Marcar la posición correcta ya validada
          break; // Salir del ciclo una vez que se cuente el número en la posición incorrecta
        }
      }
    }
  }

  // Finalmente, contamos los números incorrectos (los que no están en ninguna posición correcta o incorrecta)
  for (int i = 0; i < enteredCode.length; i++) {
    if (!countedAsCorrect[i] && !countedInCorrectCode[i]) {
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

  // Función para verificar si hay números duplicados en los campos
void _checkDuplicateNumber(String value, int index) {
  List<TextEditingController> controllers = [_controller1, _controller2, _controller3, _controller4];

  for (int i = 0; i < controllers.length; i++) {
    if (i != index && controllers[i].text == value) {
      // Si el valor es igual a otro campo, limpiar el campo actual
      controllers[index].clear();
      break; // No es necesario seguir buscando
    }
  }
}

  // Widget para crear los TextFields
  Widget _buildTextField(TextEditingController controller, FocusNode focusNode, FocusNode nextFocusNode, int index) {
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
        if (value.isNotEmpty) {
          // Verificar si el número ya está en otro campo
          _checkDuplicateNumber(value, index);

          // Si no es el último campo, pasa al siguiente
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        }
      },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);
    if (timerService.isTimeUp && !_isTimeUp) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Actualizar el estado y cerrar la pantalla
      setState(() {
        _isTimeUp = true; // Marcar que el tiempo se agotó
      });

      if(_isDialogOpen){
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
      }
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
                "Desafio 4",
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              // Espaciado flexible entre el título y el contador
              Expanded(
                child: Container(), // Expande el espacio restante para evitar que el contador se pegue al borde
              ),
              // Contador
              Container(
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
            ],
          ),
        ),
      body:Stack(
        children: [
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: Icon(Icons.help, color: Colors.white),
                onPressed: _showHelpDialog,
              ),
            ),
          ),

          Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Desafío 4: El código perdido',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ]
          )
          ),

          Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        _buildTextField(_controller1, _focusNode1, _focusNode2, 0),
                        SizedBox(width: 10),
                        _buildTextField(_controller2, _focusNode2, _focusNode3, 1),
                        SizedBox(width: 10),
                        _buildTextField(_controller3, _focusNode3, _focusNode4, 2),
                        SizedBox(width: 10),
                        _buildTextField(_controller4, _focusNode4, _focusNode4, 3), // El último campo no tiene siguiente
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
        ],
      ) 

      
    );
  }
}