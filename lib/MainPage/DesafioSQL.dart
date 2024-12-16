import 'dart:async';

import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesafioSQL extends StatefulWidget {
  
  final int desafioIndex;
  final VoidCallback onComplete;

  DesafioSQL({required this.desafioIndex, required this.onComplete});


  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<DesafioSQL> {
  TextEditingController _controllerUserBypass = TextEditingController();
  TextEditingController _controllerPassBypass = TextEditingController();

  final _controllers = List.generate(3, (_) => TextEditingController());
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  String _resultMessage = '';
  bool _isTimeUp = false; // Para saber si el tiempo se agotó

  // Clave secreta correcta (por ejemplo, 156)
  final int _correctKey = 156;

  @override
  void initState() {
    super.initState();
     
      WidgetsBinding.instance.addPostFrameCallback((_) => _showChallengeDialog());
    
  }


  void _checkKey() {
    // Combina los dígitos de los tres campos
    final enteredKey = int.tryParse(_controllers.map((e) => e.text).join()) ?? 0;

    setState(() {
      if (enteredKey == 155 ||enteredKey == 156) {
        widget.onComplete();
        Navigator.pop(context);
        _showSuccessDialog();

      } else {
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contraseña Incorrecta. Intenta de nuevo'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2), // Duración de 5 segundos
        ),
    );;
      }
    });
  }

  void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Felicidades!!",style: TextStyle(fontSize: 30.0),),
      content: Text("¡Excelente trabajo! Habéis descifrado la consulta correctamente y recuperado la clave que necesitábamos. Ahora, con la información correcta en nuestras manos, podemos seguir avanzando. ¡La Navidad está cada vez más cerca de ser salvada!",style: TextStyle(fontSize: 20.0),),
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

// Mostrar el diálogo de bienvenida del desafío
  void _showChallengeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Bienvenido al Desafío 3!'),
        content: SingleChildScrollView(  // Permite que el contenido se desplace si es largo
          child: Column(
            children: [
              Text(
                "¡Buen trabajo, elfos! Ahora que habéis restaurado el flujo de información, el siguiente reto es aún más complicado. Para continuar, debéis acceder a la base de datos secreta de Santa y realizar una consulta. Si la completáis correctamente, encontraréis la clave para avanzar en la misión. ¡Apresuraos, la Navidad se acerca!",
                style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,  // Centrar el texto para mejor apariencia
              ),
              SizedBox(height: 10),  // Espacio entre el texto y la imagen
              Image.asset(
                'assets/images/desafio_screen/database.gif',  // Ruta de la imagen de Papá Noel
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
            },
            child: Text('Entendido'),
          ),
        ],
      ),
    );
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
                "Desafio 3",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const SizedBox(height: 20),
            const Text(
              'Desafío: Desafio SQL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Santa necesita saber el coste promedio de los regalos caros '
              '(mayores a 50) en los departamentos de "REGALOS" y "LISTAS". '
              'Además, debes contar cuántos regalos cumplen con este criterio. '
              'Con estos dos valores, calcula el producto entre el coste promedio y la cantidad total de regalos, '
              'y redondea al número entero más cercano. '
              'Será el código que necesitas para completar el desafío',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
        child: ListView(
        children: [
          ExpansionTile(
            title: Text('Pista 1'),
            leading: Icon(Icons.star),
            children: [
              ListTile(
                subtitle: Text('Las tablas para el desafío están guardadas en la carpeta "Descargas", tendrás que cargarlas en SQL_PLUS.\nLas credenciales para iniciar sesión son:\nUsername: navidad\nPassword:navidad'),
              ),
            ],
          ),
        ]
        )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Primer campo de texto
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[0],
                    focusNode: _focusNode1,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(counterText: ''),
                    onChanged: (text) {
                      if (text.length == 1) {
                        // Mover el foco al siguiente campo
                        _focusNode2.requestFocus();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 30),
                // Segundo campo de texto
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[1],
                    focusNode: _focusNode2,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(counterText: ''),
                    onChanged: (text) {
                      if (text.length == 1) {
                        // Mover el foco al siguiente campo
                        _focusNode3.requestFocus();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 30),
                // Tercer campo de texto
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[2],
                    focusNode: _focusNode3,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(counterText: ''),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Botón para verificar la clave
            Center(
              child: ElevatedButton(
                onPressed: _checkKey,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Aumenta el tamaño del botón
                  textStyle: const TextStyle(
                    fontSize: 20, // Aumenta el tamaño del texto dentro del botón
                  ),
                ),
                child: const Text('Verificar Contraseña',style: TextStyle(fontSize: 20.0),),
              ),
            ),
            const SizedBox(height: 20),
            // Resultado de la verificación
            Text(
              _resultMessage,
              style: TextStyle(
                fontSize: 18,
                color: _resultMessage.startsWith('¡Correcto') ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

