import 'dart:math';
import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SopaDeLetrasScreen extends StatefulWidget {

  final int desafioIndex;
  final VoidCallback onComplete;

  SopaDeLetrasScreen({required this.desafioIndex, required this.onComplete});

  @override
  _SopaDeLetrasScreenState createState() => _SopaDeLetrasScreenState();
}

class _SopaDeLetrasScreenState extends State<SopaDeLetrasScreen> {
  final List<String> palabras = [
    'IP', 'HTTP', 'DNS', 'FTP', 'TCP', 'UDP', 'PING', 'FIREWALL', 'SUBNET', 'VPN'
  ];

  late List<List<String>> sopa;
  Set<String> celdasSeleccionadas = Set(); // Para almacenar las celdas seleccionadas
  int palabrasEncontradas = 0;
  bool _isTimeUp = false; // Para saber si el tiempo se agotó
  List<List<List<int>>> coordenadasPalabras = []; // Cambié el tipo a List<List<List<int>>>

  TextEditingController _controllerUserBypass = TextEditingController();
  TextEditingController _controllerPassBypass = TextEditingController();

  @override
  void initState() {
    super.initState();
    sopa = generarSopaDeLetras(10, palabras);
  }

  // Función para generar la sopa de letras
  List<List<String>> generarSopaDeLetras(int tamano, List<String> palabras) {
    List<List<String>> sopa = List.generate(tamano, (_) => List.generate(tamano, (_) => ' '));
    coordenadasPalabras = []; // Reiniciar las coordenadas de las palabras

    for (var palabra in palabras) {
      colocarPalabraEnSopa(sopa, palabra);
    }

    // Rellenamos el resto con letras aleatorias
    for (int i = 0; i < tamano; i++) {
      for (int j = 0; j < tamano; j++) {
        if (sopa[i][j] == ' ') {
          sopa[i][j] = _generarLetraAleatoria();
        }
      }
    }

    return sopa;
  }

  // Función para generar una letra aleatoria
  String _generarLetraAleatoria() {
    const letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return letras[random.nextInt(letras.length)];
  }

  // Función para colocar una palabra en la sopa
  void colocarPalabraEnSopa(List<List<String>> sopa, String palabra) {
    Random random = Random();
    int dir = random.nextInt(2); // 0: horizontal, 1: vertical

    bool colocada = false;
    List<List<int>> coordenadas = []; // Cambié a List<List<int>> para almacenar coordenadas

    while (!colocada) {
      int x = random.nextInt(sopa.length);
      int y = random.nextInt(sopa.length);

      if (dir == 0 && y + palabra.length <= sopa.length) {  // Horizontal
        if (_puedeColocarPalabra(sopa, palabra, x, y, dir)) {
          for (int i = 0; i < palabra.length; i++) {
            sopa[x][y + i] = palabra[i];
            coordenadas.add([x, y + i]); // Agregar coordenadas como lista de 2 elementos
          }
          colocada = true;
          coordenadasPalabras.add(coordenadas); // Guardamos las coordenadas de la palabra
        }
      } else if (dir == 1 && x + palabra.length <= sopa.length) {  // Vertical
        if (_puedeColocarPalabra(sopa, palabra, x, y, dir)) {
          for (int i = 0; i < palabra.length; i++) {
            sopa[x + i][y] = palabra[i];
            coordenadas.add([x + i, y]); // Agregar coordenadas como lista de 2 elementos
          }
          colocada = true;
          coordenadasPalabras.add(coordenadas); // Guardamos las coordenadas de la palabra
        }
      }
    }
  }

  // Función para verificar si una palabra puede ser colocada
  bool _puedeColocarPalabra(List<List<String>> sopa, String palabra, int x, int y, int dir) {
    for (int i = 0; i < palabra.length; i++) {
      if (dir == 0 && sopa[x][y + i] != ' ') {
        return false;
      } else if (dir == 1 && sopa[x + i][y] != ' ') {
        return false;
      }
    }
    return true;
  }

  // Función para manejar la selección de una casilla
  void seleccionarCelda(int x, int y) {
    setState(() {
      String celdaSeleccionada = '$x,$y';
      if (celdasSeleccionadas.contains(celdaSeleccionada)) {
        celdasSeleccionadas.remove(celdaSeleccionada); // Deseleccionamos la casilla
      } else {
        celdasSeleccionadas.add(celdaSeleccionada); // Seleccionamos la casilla
      }

      // Verificar si alguna palabra ha sido encontrada
      palabrasEncontradas = _verificarPalabrasEncontradas();

      if (palabrasEncontradas == palabras.length) {
        _mostrarDialogoFelicitacion(); // Llamamos al diálogo de felicitación
      }
    });
  }

  // Verificar las palabras encontradas
  int _verificarPalabrasEncontradas() {
    int contador = 0;
    for (var coordenadas in coordenadasPalabras) {
      bool palabraCompleta = true;
      for (var coordenada in coordenadas) {
        String coordenadaStr = '${coordenada[0]},${coordenada[1]}'; // Acceso correcto a coordenadas
        if (!celdasSeleccionadas.contains(coordenadaStr)) {
          palabraCompleta = false;
          break;
        }
      }
      if (palabraCompleta) {
        contador++;
      }
    }
    return contador;
  }

  // Función para mostrar el diálogo de felicitación
  void _mostrarDialogoFelicitacion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades!'),
        content: Text('¡Has encontrado todas las palabras!'),
        actions: [
          TextButton(
            onPressed: () {
              widget.onComplete();
              Navigator.of(context).pop(); // Cerrar el diálogo
              Navigator.pop(context);
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(child: Text('Palabras encontradas: $palabrasEncontradas')),
            Expanded(child: _crearSopa()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarPistas, // Acción del botón flotante
        child: Icon(Icons.help_outline),
        tooltip: 'Mostrar pistas',
      ),
    );
  }

   // Función para mostrar las pistas de las palabras
  void _mostrarPistas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pistas'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(palabras.length, (index) {
            String descripcion = _descripcionDePalabra(palabras[index]);
            return Text('${index + 1}. $descripcion');
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Función para obtener una breve descripción de cada palabra
  String _descripcionDePalabra(String palabra) {
    switch (palabra) {
      case 'IP':
        return 'Protocolo de red para direccionamiento.';
      case 'HTTP':
        return 'Protocolo de transferencia de hipertexto.';
      case 'DNS':
        return 'Sistema de nombres de dominio.';
      case 'FTP':
        return 'Protocolo para transferencia de archivos.';
      case 'TCP':
        return 'Protocolo de control de transmisión.';
      case 'UDP':
        return 'Protocolo de datagramas de usuario.';
      case 'SUBNET':
        return 'División de una red mayor en subredes más pequeñas para mejorar la gestión y seguridad de la red.';
      case 'FIREWALL':
        return 'Sistema de seguridad que monitoriza y controla el tráfico de red, bloqueando accesos no autorizados.';
      case 'PING':
        return 'Herramienta utilizada para comprobar la conectividad entre dos dispositivos en una red mediante la emisión de un paquete de datos.';
      case 'VPN':
        return 'Red privada virtual.';
      default:
        return 'Sin descripción disponible.';
    }
  }

  // Widget para crear la sopa de letras
  Widget _crearSopa() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10, // Tamaño fijo de la cuadrícula
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: sopa.length * sopa.length,
      itemBuilder: (context, index) {
        int row = index ~/ sopa.length;
        int col = index % sopa.length;

        String celda = sopa[row][col];
        bool estaSeleccionada = celdasSeleccionadas.contains('$row,$col');

        return GestureDetector(
          onTap: () => seleccionarCelda(row, col),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: estaSeleccionada ? Colors.blue : Colors.white, // Cambio de color
            ),
            child: Text(
              celda,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: estaSeleccionada ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}