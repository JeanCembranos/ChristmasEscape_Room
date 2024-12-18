import 'dart:async';
import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DesafioDEV extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;

  DesafioDEV({required this.desafioIndex, required this.onComplete});

  @override
  _Desafio2ScreenState createState() => _Desafio2ScreenState();
}

class _Desafio2ScreenState extends State<DesafioDEV> {
  bool _isTask1Visible = true;
  bool _isTask2Visible = false;
  bool _isTask1Expanded = true;
  bool _isTask2Expanded = true;

  bool _isQRCodeDetected = false;
  bool isVerified = false; 
   String qrResult = "";
   bool _isTimeUp = false; // Para saber si el tiempo se agotó


  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  bool _isMayorCantidadCaracteresCorrect = false;
  bool _isCantidadTotalRegalosCorrect = false;
  bool _isCantidadTotalUsuariosCorrect = false;
  bool _isSumaTotalCaracteresCorrect = false;

  TextEditingController _controllerMayorCantidadCaracteres = TextEditingController();
  TextEditingController _controllerCantidadTotalRegalos = TextEditingController();
  TextEditingController _controllerCantidadTotalUsuarios = TextEditingController();
  TextEditingController _controllerSumaTotalCaracteres = TextEditingController();

  TextEditingController _controllerUserBypass = TextEditingController();
  TextEditingController _controllerPassBypass = TextEditingController();

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) => _showChallengeDialog());
    
  }
  @override
    void dispose() {
      //widget.timer.cancel(); // Detener el temporizador cuando el widget se destruya
      super.dispose();
    }

  String? _validateMayorCantidadCaracteres(String? value) {
    if (value != null && value.isNotEmpty && value == '23') {
      setState(() {
        _isMayorCantidadCaracteresCorrect = true;
      });
      return null;
    } else {
      setState(() {
        _isMayorCantidadCaracteresCorrect = false;
      });
      return 'Cantidad Incorrecta';
    }
  }

  String? _validateCantidadTotalRegalos(String? value) {
    if (value != null && value.isNotEmpty && value == '112') {
      setState(() {
        _isCantidadTotalRegalosCorrect = true;
      });
      return null;
    } else {
      setState(() {
        _isCantidadTotalRegalosCorrect = false;
      });
      return 'Cantidad Incorrecta';
    }
  }

  String? _validateCantidadTotalUsuarios(String? value) {
    if (value != null && value.isNotEmpty && value == '121') {
      setState(() {
        _isCantidadTotalUsuariosCorrect = true;
      });
      return null;
    } else {
      setState(() {
        _isCantidadTotalUsuariosCorrect = false;
      });
      return 'Cantidad Incorrecta';
    }
  }

  String? _validateSumaTotalCaracteres(String? value) {
    if (value != null && value.isNotEmpty && value == '1156') {
      setState(() {
        _isSumaTotalCaracteresCorrect = true;
      });
      return null;
    } else {
      setState(() {
        _isSumaTotalCaracteresCorrect = false;
      });
      return 'Cantidad Incorrecta';
    }
  }
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
  void _showChallengeDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('¡Bienvenido al Desafío 9!'),
      content: SingleChildScrollView(  // Permite que el contenido se desplace si es largo
        child: Column(
          children: [
            Text(
              "El taller de Santa está lleno de pistas, pero el tiempo corre en vuestra contra. Para avanzar y recuperar la magia navideña, necesitaréis utilizar vuestros conocimientos de programación en Java. El código que conecta las pistas está dañado, y solo resolviendo los errores clave podréis desbloquear el siguiente paso. ¡Usad vuestras habilidades y salvad la Navidad!",
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,  // Centrar el texto para mejor apariencia
            ),
            SizedBox(height: 10),  // Espacio entre el texto y la imagen
            Image.asset(
              'assets/images/desafio_screen/font_code.gif',  // Ruta de la imagen de Papá Noel
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cerrar el diálogo
            //_showFloatingIcon();
          },
          child: Text('Entendido'),
        ),
      ],
    ),
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
                "Desafio 9",
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
      body: ListView(
        children: [
          if (_isTask1Visible && _isTask1Expanded) 
          ExpansionTile(
            title: Text('Pista 1'),
            leading: Icon(Icons.star),
            children: [
              ListTile(
                title: Text(''),
                subtitle: Text('Encuentra el ordenador que contiene los archivos para tu siguiente desafío'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _openQRCodeScanner();
                  },
                  child: Text('Escanear QR'),
                ),
              ),
            ],
            initiallyExpanded: true,
          ),
          if (_isTask1Visible && !_isTask1Expanded)
          ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // El texto "Pista 1"
                    Text('Pista 1'),

                    // Icono de check en un círculo verde
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Espaciado entre el texto y el icono
                      child: CircleAvatar(
                        radius: 12, // Tamaño del círculo
                        backgroundColor: Colors.green, // Color de fondo del círculo
                        child: Icon(
                          Icons.check, // Icono de check
                          color: Colors.white, // Color del icono (blanco)
                          size: 16, // Tamaño del icono
                        ),
                      ),
                    ),
                  ],
                ),
                enabled: false, // Deshabilita la expansión
              ), 

          // Pista 2 - Formulario
          if (_isTask2Visible && _isTask2Expanded)
            ExpansionTile(
              title: Text('Pista 2'),
              leading: Icon(Icons.star),
              children: [
                ListTile(
                  title: Text('En el directorio "Documentos" encontrarás el proyecto que necesitas"\nEste te guiará hasta obtener los códigos finales que deberás ingresar aquí'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey, // Form key para validación
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _controllerMayorCantidadCaracteres,
                          decoration: InputDecoration(
                            labelText: 'Mayor cantidad de Caracteres',
                            suffixIcon: isVerified
                                ? (_isMayorCantidadCaracteresCorrect
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.close, color: Colors.red))
                                : null,  // No muestra el icono hasta verificar
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validateMayorCantidadCaracteres,
                        ),
                        TextFormField(
                          controller: _controllerCantidadTotalRegalos,
                          decoration: InputDecoration(
                            labelText: 'Cantidad Total de Regalos',
                            suffixIcon: isVerified
                                ? (_isCantidadTotalRegalosCorrect
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.close, color: Colors.red))
                                : null,  // No muestra el icono hasta verificar
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validateCantidadTotalRegalos,
                        ),
                        TextFormField(
                          controller: _controllerCantidadTotalUsuarios,
                          decoration: InputDecoration(
                            labelText: 'Cantidad Total de Usuarios',
                            suffixIcon: isVerified
                                ? (_isCantidadTotalUsuariosCorrect
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.close, color: Colors.red))
                                : null,  // No muestra el icono hasta verificar
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validateCantidadTotalUsuarios,
                        ),
                        TextFormField(
                          controller: _controllerSumaTotalCaracteres,
                          decoration: InputDecoration(
                            labelText: 'Suma Total de Caracteres',
                            suffixIcon: isVerified
                                ? (_isSumaTotalCaracteresCorrect
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.close, color: Colors.red))
                                : null,  // No muestra el icono hasta verificar
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validateSumaTotalCaracteres,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              widget.onComplete();
                              Navigator.pop(context);
                              _showSuccessDialog();
                            }
                          },
                          child: Text("Verificar"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¡Lo habéis conseguido!"),
        content: Text("¡Todos los valores son correctos!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Cualquier lógica adicional cuando el desafío se complete
            },
            child: Text("Avanzar"),
          ),
        ],
      ),
    );
  }

  void _handleQRCodeResult(BarcodeCapture barcodeCapture) {
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
     if (qrResult == "codigo_java") {
      _showCorrectQRCodeDialog();
      setState(() {
        _isTask2Visible = true; // Mostrar la siguiente tarea
        _isTask1Expanded = false;
      });
    } else {
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
  }

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
}