import 'dart:async';

import 'package:flutter/material.dart';

class DesafioSQL extends StatefulWidget {
  
  final int desafioIndex;
  final VoidCallback onComplete;
  int totalSeconds;
  Timer? timer;

  DesafioSQL({required this.desafioIndex, required this.onComplete,required this.timer,required this.totalSeconds});


  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<DesafioSQL> {
  final _controllers = List.generate(3, (_) => TextEditingController());
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  String _resultMessage = '';

  // Clave secreta correcta (por ejemplo, 156)
  final int _correctKey = 156;

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
      title: Text("¡Correcto!",style: TextStyle(fontSize: 30.0),),
      content: Text("Felicidades. Has completado el desafio SQL",style: TextStyle(fontSize: 20.0),),
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
        backgroundColor: Colors.red, // Establece el color rojo en el AppBar
        title: const Text(
          'Desafio SQL',
          style: TextStyle(
            color: Colors.white, // Color del texto en blanco
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
                subtitle: Text('Las tablas para el desafío están guardadas en la carpeta "Descargas", tendrás que cargarlas en SQL_PLUS.\nLas credenciales para iniciar sesión son:\nUsername: jc\nPassword:jc'),
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

/*class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final _controller = TextEditingController();
  String _resultMessage = '';

  // Clave secreta correcta (por ejemplo, 156)
  final int _correctKey = 156;

  void _checkKey() {
    // Verifica si la clave ingresada es correcta
    final int enteredKey = int.tryParse(_controller.text) ?? 0;

    setState(() {
      if (enteredKey == _correctKey) {
        _resultMessage = '¡Correcto! Has salvado la Navidad.';
      } else {
        _resultMessage = 'Clave incorrecta. Intenta de nuevo.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Establece el color rojo en el AppBar
        title: const Text(
          'Desafio SQL',
          style: TextStyle(
            color: Colors.white, // Color del texto en blanco
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
                subtitle: Text('Las tablas para el desafío están guardadas en la carpeta "Descargas", tendrás que cargarlas en SQL_PLUS.\nLas credenciales para iniciar sesión son:\nUsername: jc\nPassword:jc'),
              ),
            ],
          ),
        ]
        )
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Introduce la clave secreta',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Botón para verificar la clave
            ElevatedButton(
              onPressed: _checkKey,
              child: const Text('Verificar Clave'),
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
}*/