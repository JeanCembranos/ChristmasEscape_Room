import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Desafio2Screen extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;
  int totalSeconds;
  Timer? timer;

  Desafio2Screen({required this.desafioIndex, required this.onComplete,required this.timer,required this.totalSeconds});

  @override
  _Desafio2ScreenState createState() => _Desafio2ScreenState();
}
class _Desafio2ScreenState extends State<Desafio2Screen> {
  bool _isTask1Visible = true;
  bool _isTask2Visible = false; // Variable para controlar si la siguiente tarea es visible
  bool _isQRCodeDetected = false;
   String qrResult = ""; // Almacenar el resultado del escaneo
   bool _showFloatingButton = false;
  bool _isTimeUp = false; // Para saber si el tiempo se agotó
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    //_startTimer(); // Iniciar el temporizador cuando la app se inicie
      WidgetsBinding.instance.addPostFrameCallback((_) => _showChallengeDialog());
    
  }
  @override
    void dispose() {
      //widget.timer.cancel(); // Detener el temporizador cuando el widget se destruya
      super.dispose();
    }

void _showChallengeDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('¡Bienvenido al Desafío 2!'),
      content: SingleChildScrollView(  // Permite que el contenido se desplace si es largo
        child: Column(
          children: [
            Text(
              "Santa se dispone a abrir la lista de regalos de este año. La ha guardado en su ordenador pero......Oh no! HAY UN PROBLEMA, Santa no recuerda donde lo dejó. Ayuda a Santa a encontrar su ordenador.",
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,  // Centrar el texto para mejor apariencia
            ),
            SizedBox(height: 10),  // Espacio entre el texto y la imagen
            Image.asset(
              'assets/images/desafio_screen/papanoel.gif',  // Ruta de la imagen de Papá Noel
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
            _showFloatingIcon();
          },
          child: Text('Entendido'),
        ),
      ],
    ),
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
      body: ListView(
        children: [
          if (_isTask1Visible) 
          ExpansionTile(
            title: Text('Desafío 1'),
            leading: Icon(Icons.star),
            children: [
              ListTile(
                title: Text('Pistas:'),
                subtitle: Text('El ordenador de Santa tiene una pegatina.....Encuéntrala'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _openQRCodeScanner();
                  },
                  child: Text('Escanear QR'),
                ),
              ),
            ],
          ),
          if (_isTask2Visible) 
            ExpansionTile(
      title: Text('Desafío 2'),
      leading: Icon(Icons.star),
      children: [
        ListTile(
          title: Text('Pistas:'),
          subtitle: Text(
              'Gracias! Ahora podemos entrar...pero...no recuerdo la contraseña\nCreo que la tenía en un archivo dentro de la ruta: Documents/Archivos_Santa\nLa ves? Pues búscala e ingresa la contraseña aquí'),
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
                if (_controller.text == "santa1234") {
                  // Si es correcto, mostramos el diálogo
                  widget.onComplete();
                  Navigator.pop(context);
                  _showSuccessDialog();
                  /*Future.delayed(Duration(milliseconds: 300), () {
                    Navigator.pop(context); // Esto cierra la ventana del desafío
                  });*/
                } else {
                  // Si no es correcto, mostramos un mensaje de error o lo que sea necesario
                }
              },
                
              child: Text('Abrir Lista de Regalos'),
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
)
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
      title: Text("¡Contraseña Correcta!"),
      content: Text("¡El código es correcto! Ahora puedes avanzar."),
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