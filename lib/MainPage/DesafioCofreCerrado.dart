import 'dart:async';

import 'package:flutter/material.dart';

class DesafioCofreCerrado extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;
  int totalSeconds;
  Timer? timer;

  DesafioCofreCerrado({required this.desafioIndex, required this.onComplete,required this.timer,required this.totalSeconds});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<DesafioCofreCerrado> {
  List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  int _incorrectAttempts = 0;  // Contador de intentos incorrectos
  bool _isTask1Visible = true;
  bool _isTask2Visible = false;
  // Variable para almacenar la respuesta ingresada
  bool _showFloatingButton = false;
  final TextEditingController _controller = TextEditingController();

  // Variable para mostrar si la respuesta es correcta o incorrecta
  String _message = '';


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
      title: Text('¡Bienvenido al Desafío 1!'),
      content: SingleChildScrollView(  // Permite que el contenido se desplace si es largo
        child: Column(
          children: [
            Text(
              "¡El taller de Santa está lleno de magia y misterio! El cofre antiguo que guarda una clave esencial para recuperar el Espíritu Navideño está sellado con un código secreto. Pero este no es un código común; está oculto en símbolos que sólo pueden ser transformados por mentes agudas. Como elfos secretos, vuestra misión es encontrar la forma correcta de descifrar el código. ¡Solo cuando logréis revelar su verdadero valor, el cofre se abrirá y podréis avanzar en la misión para salvar la Navidad!",
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,  // Centrar el texto para mejor apariencia
            ),
            SizedBox(height: 10),  // Espacio entre el texto y la imagen
            Image.asset(
              'assets/images/desafio_screen/cofre.png',  // Ruta de la imagen de Papá Noel
              width: 150,
              height: 150,
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

  // Lógica para verificar si la respuesta es correcta
  void _checkAnswer() {
    String answer = _controllers.map((controller) => controller.text).join('');
    if (answer == '138415') {  // Suponiendo que la respuesta correcta es '419'
      setState(() {
        widget.onComplete();
        Navigator.pop(context);
        _showSuccessDialog();
        _incorrectAttempts = 0;  // Reinicia el contador de intentos
      });
    } else {
      setState(() {
        _message = 'Incorrecto. Intenta transformar el código para encontrar el valor correcto.';
        _incorrectAttempts += 1;  // Incrementa el contador de intentos incorrectos
      });
      
      // Si se han hecho 3 intentos incorrectos, mostramos la segunda pista
      if (_incorrectAttempts == 3) {
        setState(() {
          _isTask2Visible = true;  // Muestra la segunda pista
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrecto. Intenta transformar el código para encontrar el valor correcto.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5), // Duración de 5 segundos
        ),
    );
    }
  }

   void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("¡Correcto!",style: TextStyle(fontSize: 30.0),),
      content: Text("Felicidades. Has abierto el cofre, avanzarás al siguiente desafío",style: TextStyle(fontSize: 20.0),),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // AppBar roja
        title: const Text(
          'La Misión de Santa: El Robo del Espíritu Navideño',
          style: TextStyle(
            color: Colors.white, // Texto blanco en el AppBar
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const SizedBox(height: 20),
            const Text(
              'Desafío 1: El Cofre Cerrado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'El cofre está cerrado con un código antiguo, pero no es un código común. Para abrirlo, deben transformarlo para encontrar su verdadero valor. Solo aquellos que logren cambiar su forma podrán abrirlo.',
              style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
        
        Expanded(
        child: ListView(
        children: [
          if (_isTask1Visible) 
          ExpansionTile(
            title: Text('Pista 1'),
            leading: Icon(Icons.star),
            children: [
              ListTile(
                subtitle: Text('(lugar donde estara escondido el codigo)'),
              ),
            ],
          ),
          if (_isTask2Visible) 
          ExpansionTile(
            title: Text('Pista 2'),
            leading: Icon(Icons.star),
            children: [
              ListTile(
                subtitle: Text('El código está compuesto por símbolos que no hablan por sí mismos. Si deseas entender su verdadero significado, debes mirar más allá de lo evidente. Transforma los valores antiguos en algo más familiar. Solo entonces la verdad será revelada.'),
              ),
            ],
          )
        ]
            )
        ),
            
           

            Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centra los campos
                children: [
                  _buildNumberField(0),
                  SizedBox(width: 8), // Espacio entre los campos
                  _buildNumberField(1),
                  SizedBox(width: 8),
                  _buildNumberField(2),
                  SizedBox(width: 8),
                  _buildNumberField(3),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Color del botón rojo
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                  child: const Text(
                    'Enviar Respuesta',
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  // Función para construir cada TextField con estilo
// Función para construir cada TextField con estilo
Widget _buildNumberField(int index) {
  return Container(
    width: 80,
    height: 150,
     // Más ancho para permitir dos dígitos
    child: TextField(
      controller: _controllers[index],  // Necesitarás una lista de controladores
      style: TextStyle(color: Colors.white),
      maxLength: 2,  // Permite hasta dos dígitos
      textAlign: TextAlign.center, // Centra el texto en el campo
      decoration: InputDecoration(
        counterText: '',  // Elimina el contador de caracteres
        filled: true,
        fillColor: Colors.black87,  // Fondo oscuro
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),  // Borde negro
        ),
      ),
    ),
  );
}
}