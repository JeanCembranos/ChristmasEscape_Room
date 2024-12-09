import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DesafioCaminoQR extends StatefulWidget {

  final int desafioIndex;
  final VoidCallback onComplete;
  int totalSeconds;
  Timer? timer;

  DesafioCaminoQR({required this.desafioIndex, required this.onComplete,required this.timer,required this.totalSeconds});

  @override
  _DesafioScreenState createState() => _DesafioScreenState();
}

class _DesafioScreenState extends State<DesafioCaminoQR> {
  // Variable para controlar si los ExpansionTiles están expandidos o no
  bool _isQRCodeDetected = false;
   String qrResult = ""; // Almacenar el resultado del escaneo
  bool _isTask2Visible = false;
  bool _isTask3Visible = false;
  bool _isTask4Visible = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Desafío de los Códigos QR',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Primer ExpansionTile
            
            ExpansionTile(
              title: Text('Pista 1'),
              children: [
                Text('En la noche fría de Navidad, Santa se asegura de estar bien abrigado. Entre sus prendas, cuelga algo que siempre está a la vista. Para encontrar lo que buscas, no olvides que todo lo que necesitas para abrigarte, lo puedes colgar aquí. Busca donde lo que cuelga es parte de lo que más se usa en esta época del año.\nSi crees haber encontrado el código, escanéalo'),
                ElevatedButton(
                  onPressed: () {
                    _openQRCodeScanner();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding personalizado para agrandar el botón
                    textStyle: TextStyle(fontSize: 18), // Aumenta el tamaño del texto
                  ),
                  child: Text('Escanear QR'),
                ),
              ],
            ),

            // Segundo ExpansionTile
            if(_isTask2Visible)
            ExpansionTile(
              title: Text('Pista 2'),
              children: [
                Text('En el aula, el conocimiento se comparte, pero el maestro sabe que su sabiduría está cerca de su silla. No está sobre la mesa, pero sí bajo ella, donde descansa lo que ayuda a enseñar sin parar.\nSi crees haber encontrado el código, escanéalo'),
                ElevatedButton(
                  onPressed: () {
                    _openQRCodeScanner();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding personalizado para agrandar el botón
                    textStyle: TextStyle(fontSize: 18), // Aumenta el tamaño del texto
                  ),
                  child: Text('Escanear QR'),
                ),
              ],
            ),

            // Tercer ExpansionTile
            if(_isTask3Visible)
            ExpansionTile(
              title: Text('Pista 3'),
              children: [
                Text('Cuando la luz se apaga y la pantalla cobra vida, el conocimiento se proyecta ante ti. No busques en lo oscuro, sino donde la imagen se ilumina, en lo alto, verás la respuesta brillar.\nSi crees haber encontrado el código, escanéalo'),
                ElevatedButton(
                  onPressed: () {
                    _openQRCodeScanner();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding personalizado para agrandar el botón
                    textStyle: TextStyle(fontSize: 18), // Aumenta el tamaño del texto
                  ),
                  child: Text('Escanear QR'),
                ),
              ],
            ),


            // Cuarto ExpansionTile
            if(_isTask4Visible)
            ExpansionTile(
              title: Text('Pista 4'),
              children: [
                Text('Al final del camino, te encontrarás con una barrera, un obstáculo que te detiene antes de continuar. No está al frente, ni sobre lo que ves, busca en lo que te bloquea el paso, y la solución encontrarás.\nSi crees haber encontrado el código, escanéalo'),
                ElevatedButton(
                  onPressed: () {
                    _openQRCodeScanner();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding personalizado para agrandar el botón
                    textStyle: TextStyle(fontSize: 18), // Aumenta el tamaño del texto
                  ),
                  child: Text('Escanear QR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*void _handleQRCodeResult(BarcodeCapture barcodeCapture) {
  // Si ya hemos detectado un código, no hacer nada
  if (_isQRCodeDetected) return;

  // Obtener el primer barcode escaneado
  String qrResult = barcodeCapture.barcodes.isNotEmpty
      ? barcodeCapture.barcodes.first.rawValue ?? ""
      : "";  // Almacenar el valor del QR, si hay algún barcode detectado

  if (qrResult.isNotEmpty) {
    // Marcar como detectado para evitar nuevas detecciones
    setState(() {
      _isQRCodeDetected = true; // Marcar como detectado
      this.qrResult = qrResult;
    });
    // Detener la cámara y regresar a la pantalla anterior
    Navigator.pop(context); // Cierra la vista del escáner QR

    // Verificar el resultado del código QR escaneado
     if (qrResult == "codigo1") {
      _showCorrectQRCodeDialog();
      setState(() {
        _isTask2Visible = true; // Mostrar la siguiente tarea
      });
    } else if (qrResult == "codigo2" && _isTask2Visible) {
      _showCorrectQRCodeDialog();
      setState(() {
        _isTask3Visible = true; // Mostrar la siguiente tarea
      });
    }else if (qrResult == "codigo3" && _isTask2Visible) {
      _showCorrectQRCodeDialog();
      setState(() {
        _isTask4Visible = true; // Mostrar la siguiente tarea
      });
    }else{
      _showIncorrectQRCodeDialog();
    }

    // Puedes reiniciar la detección después de un corto retraso
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _isQRCodeDetected = false; // Permitir una nueva detección después de 2 segundos
      });
    });
  }
}

  // Mostrar un diálogo si el código QR es correcto
  void _showCorrectQRCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¡Código Correcto!"),
        content: Text("¡El código QR es correcto!"),
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
  }*/
  
  
  // Mostrar un diálogo si el código QR es incorrecto
  void _showIncorrectQRCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Código Incorrecto"),
        content: Text("El código QR no es el esperado."),
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
   // Método para abrir el escáner QR
  void _openQRCodeScanner() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MobileScanner(
        onDetect: (barcodeCapture) => _handleQRCodeResult(barcodeCapture),
      ),
    ),
  );
}




void _handleQRCodeResult(BarcodeCapture barcodeCapture) {
    if (_isQRCodeDetected) return;

    String qrResult = barcodeCapture.barcodes.isNotEmpty
        ? barcodeCapture.barcodes.first.rawValue ?? ""
        : "";

    if (qrResult.isNotEmpty) {
      setState(() {
        _isQRCodeDetected = true;
        this.qrResult = qrResult;
      });

      Navigator.pop(context); // Cierra el escáner QR

      // Verificar el resultado del código QR escaneado
     if (qrResult == "codigo1") {
        _showMiniChallenge1Dialog();
      setState(() {
        _isTask2Visible = true; // Mostrar la siguiente tarea
      });
    } else if (qrResult == "codigo2" && _isTask2Visible) {
      _showMiniChallenge2Dialog();
      setState(() {
        _isTask3Visible = true; // Mostrar la siguiente tarea
      });
    }else if (qrResult == "codigo3" && _isTask3Visible) {
      _showMiniChallenge3Dialog();
      setState(() {
        _isTask4Visible = true; // Mostrar la siguiente tarea
      });
    }else if (qrResult == "codigo4" && _isTask4Visible){
      _showMiniChallenge4Dialog();
    }else{
      _showIncorrectQRCodeDialog();
    }

      // Permitir nueva detección después de 4 segundos
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          _isQRCodeDetected = false;
        });
      });
    }
  }

  // Mostrar un diálogo cuando el código QR es correcto
  void _showCorrectQRCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¡Código Correcto!"),
        content: Text("¡El código QR es correcto!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo
              _showMiniChallenge1Dialog(); // Mostrar el mini-desafío
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showMiniChallenge1Dialog() {
  // Controlador para la respuesta del usuario
  TextEditingController answerController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false, // Impide que el diálogo se cierre tocando fuera de él
    builder: (context) {
      return PopScope(
       canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Mini Desafío: Convierte el número decimal 26 a binario"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Aquí le damos un TextField para que el usuario ingrese la respuesta
                  Text("Debes resolver este Mini - Desafío para continuar el camino"),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(labelText: "Tu respuesta (en binario)"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Obtener la respuesta del usuario
                    String userAnswer = answerController.text.trim();
                    String correctAnswer = '11010'; // Convierte 26 a binario

                    // Verificar si la respuesta es correcta
                    if (userAnswer == correctAnswer) {
                      // Si es correcta, mostrar un diálogo de éxito
                      Navigator.pop(context); // Cerrar el diálogo de desafío
                    } else {
                      // Si es incorrecta, mostrar un diálogo de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Incorrecto. Inténtalo nuevamente'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 5), // Duración de 5 segundos
                        ),
                      );
                    }
                  },
                  child: Text("Enviar respuesta"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
void _showMiniChallenge2Dialog() {
  // Controlador para la opción seleccionada
  String selectedOption = "";

  showDialog(
    context: context,
    barrierDismissible: false, // Evitar que el diálogo se cierre tocando fuera de él
    builder: (context) {
      return PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Mini Desafío: ¿Cuántos bits tiene una dirección IPv4?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Opción múltiple con RadioListTile para seleccionar la respuesta
                  RadioListTile<String>(
                    title: Text("8 bits"),
                    value: "8",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text("16 bits"),
                    value: "16",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text("32 bits"),
                    value: "32",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text("64 bits"),
                    value: "64",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Verificar si la respuesta es correcta
                    if (selectedOption == "32") {
                      // Si es correcta, cerrar el diálogo
                      Navigator.pop(context); // Cerrar el diálogo de desafío
                    } else {
                      // Si es incorrecta, mostrar un mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Incorrecto. Inténtalo nuevamente'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2), // Duración de 2 segundos
                        ),
                      );
                    }
                  },
                  child: Text("Enviar respuesta"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

void _showMiniChallenge3Dialog() {
  String _selectedOption = "";

  showDialog(
    context: context,
    barrierDismissible: false, // Impide que el diálogo se cierre tocando fuera de él
    builder: (context) {
      return PopScope(
       canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Mini Desafío: Máscara de Subred"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("¿Cuál es la máscara de subred predeterminada para una red clase C?"),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      // Opción 1
                      RadioListTile<String>(
                        title: Text('255.255.255.0'),
                        value: '255.255.255.0',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      // Opción 2
                      RadioListTile<String>(
                        title: Text('255.255.254.0'),
                        value: '255.255.254.0',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      // Opción 3
                      RadioListTile<String>(
                        title: Text('255.255.255.255'),
                        value: '255.255.255.255',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      // Opción 4
                      RadioListTile<String>(
                        title: Text('255.255.0.0'),
                        value: '255.255.0.0',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_selectedOption == '255.255.255.0') {
                      // Respuesta correcta
                      Navigator.pop(context); // Cierra el diálogo si es correcto
                    } else {
                      // Respuesta incorrecta
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Incorrecto. Inténtalo nuevamente'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2), // Duración de 2 segundos
                        ),
                      );
                    }
                  },
                  child: Text('Verificar'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

void _showMiniChallenge4Dialog() {
  String _selectedOption = "";

  showDialog(
    context: context,
    barrierDismissible: false, // Impide que el diálogo se cierre tocando fuera de él
    builder: (context) {
      return PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Mini Desafío: Estructura de Datos LIFO"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("¿Qué estructura de datos utiliza un enfoque de 'último en entrar, primero en salir' (LIFO)?"),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      // Opción 1
                      RadioListTile<String>(
                        title: Text('Pila (Stack)'),
                        value: 'Pila (Stack)',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      // Opción 2
                      RadioListTile<String>(
                        title: Text('Cola (Queue)'),
                        value: 'Cola (Queue)',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      // Opción 3
                      RadioListTile<String>(
                        title: Text('Árbol Binario'),
                        value: 'Árbol Binario',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      // Opción 4
                      RadioListTile<String>(
                        title: Text('Lista Enlazada'),
                        value: 'Lista Enlazada',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_selectedOption == 'Pila (Stack)') {
                      // Respuesta correcta
                      Navigator.pop(context);
                      _showCompletionDialog();
                    } else {
                      // Respuesta incorrecta
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Incorrecto. Inténtalo nuevamente'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2), // Duración de 2 segundos
                        ),
                      );
                    }
                  },
                  child: Text('Verificar'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
void _showCompletionDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // Impide cerrar tocando fuera del diálogo
    builder: (context) {
      return PopScope(
       canPop: false,
        child: AlertDialog(
          title: Text("¡Felicidades!"),
          content: Text("¡Has completado el camino!"),
          actions: [
            TextButton(
              onPressed: () {
                widget.onComplete();
                Navigator.pop(context); // Cierra el diálogo y regresa a la pantalla anterior
                Navigator.pop(context);
              },
              child: Text("Avanzar"),
            ),
          ],
        ),
      );
    },
  );
}
}