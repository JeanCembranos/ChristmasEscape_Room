import 'dart:async';
import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class Desafio2Screen extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;

  Desafio2Screen({required this.desafioIndex, required this.onComplete});

  @override
  _Desafio2ScreenState createState() => _Desafio2ScreenState();
}
class _Desafio2ScreenState extends State<Desafio2Screen> {
  bool _isTask1Visible = true;
  bool _isTask2Visible = false; // Variable para controlar si la siguiente tarea es visible

  bool _isTask1Expanded = true;
  bool _isTask2Expanded = true;
  bool _isDialogOpen = false;

  bool _isQRCodeDetected = false;
   String qrResult = ""; // Almacenar el resultado del escaneo
   bool _showFloatingButton = false;
  bool _isTimeUp = false; // Para saber si el tiempo se agotó
  TextEditingController _controller = TextEditingController();
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

void _showChallengeDialog() {
  _isDialogOpen = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
    child: AlertDialog(
      title: Text('¡Bienvenido al Desafío 7!'),
      content: SingleChildScrollView(  // Permite que el contenido se desplace si es largo
        child: Column(
          children: [
            Text(
              "En esta etapa de la misión, un ordenador del taller podría contener pistas cruciales para avanzar. Sin embargo, su contenido parece estar desordenado, casi como si alguien hubiera intentado ocultar información. Entre los archivos, hay uno que podría ser la clave para resolver el enigma, pero algo parece fuera de lugar. Examina cuidadosamente, encuentra lo que necesitas y descifra su propósito para desbloquear el siguiente paso hacia la salvación de la Navidad.",
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,  // Centrar el texto para mejor apariencia
            ),
            SizedBox(height: 10),  // Espacio entre el texto y la imagen
            Image.asset(
              'assets/images/desafio_screen/directorio.gif',  // Ruta de la imagen de Papá Noel
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _isDialogOpen = false;
            Navigator.pop(context); // Cerrar el diálogo
            _showFloatingIcon();
          },
          child: Text('Entendido'),
        ),
      ],
    ),
    )
  );
}

 // Función para mostrar el ícono flotante
  void _showFloatingIcon() {
    setState(() {
      _showFloatingButton = true;
    });
  }

  // Función que abre el popup cuando el ícono flotante es presionado
  void _openPopupFromFloatingActionButton() {
    _showChallengeDialog();
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
                "Desafio 7",
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


         if (_isTask2Visible && _isTask2Expanded)
            ExpansionTile(
      title: Text('Pista 2'),
      leading: Icon(Icons.star),
      children: [
        ListTile(
          title: Text(''),
          subtitle: Text(
              'En el directorio "Documentos" encontrarás una carpeta con el nombre "Archivos_Santa"\nLa ves? Es especial, si la buscas la encontrarás\nCuando resuelvas el misterio, ingresa el código que contiene, aquí'),
        ),
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Centrar todos los elementos
        children: [
          // TextField con estilo mejorado
          Container(
            width: double.infinity,  // Hacer que el TextField ocupe todo el ancho disponible
            child: TextField(
              controller: _controller,  // Este es el controlador para capturar el texto
              decoration: InputDecoration(
                labelText: 'Ingrese la contraseña',
                labelStyle: TextStyle(color: Colors.redAccent), // Color del texto del label
                filled: true,  // Fondo relleno
                fillColor: Colors.grey[200], // Color de fondo del TextField
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                  borderSide: BorderSide(
                    color: Colors.redAccent, // Color del borde
                    width: 2.0, // Ancho del borde
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                  borderSide: BorderSide(
                    color: Colors.green, // Color cuando el TextField está enfocado
                    width: 2.0, // Ancho del borde enfocado
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),  // Espacio entre el TextField y el botón
          // Botón centrado
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.toLowerCase() == "roscareyes") {
                  // Si es correcto, mostramos el diálogo
                  widget.onComplete();
                  Navigator.pop(context);
                  _showSuccessDialog();
                  
                } else if (_controller.text.toLowerCase() == "urvfduhbhv"){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lo has encontrado, pero le falta algo.....Intenta desencriptarlo\nC_3_Izq'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 10), // Duración de 5 segundos
                    ),
                );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Código Incorrecto. Intenta nuevamente'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2), // Duración de 5 segundos
                    ),
                );
                }
              },
                
              child: Text('Enviar Código'),
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // Color del fondo del botón
              foregroundColor: Colors.white, // Color del texto en el botón
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Relleno del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordes redondeados
                ),
                elevation: 5, // Sombra del botón
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          initiallyExpanded: true,
        ),
        ],
      ),
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
              onPressed: _openPopupFromFloatingActionButton,
              child: Icon(Icons.info_outline), // Puedes usar cualquier icono que desees
              backgroundColor: Colors.redAccent, // Puedes cambiar el color del ícono flotante
            )
          : null, // Si _showFloatingButton es false, no mostrar el ícono*/
          
      );
  }
  void _advanceToNextTask() {
  // Lógica para avanzar a la siguiente tarea

  // Aquí cerramos la ventana del desafío, ya que el código es correcto y el usuario ha presionado "Avanzar"
  Navigator.pop(context); // Cerrar la ventana del desafío

  // También puedes colocar aquí cualquier otra lógica para avanzar, por ejemplo, mostrar otro ExpansionTile
}
  void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("¡Lo habéis conseguido!"),
      content: Text("Gracias al trabajo en equipo y a vuestra astucia, habéis resuelto el misterio del ordenador. La contraseña que habéis descifrado es un paso clave para recuperar el Espíritu Navideño. Habéis demostrado ser un grupo de elfos a la altura de esta misión, pero aún queda camino por recorrer. ¡Adelante, la Navidad está en vuestras manos!"),
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
     if (qrResult == "codigo_qr") {
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