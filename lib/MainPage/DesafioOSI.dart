
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:christmas_project/Timer_Tools/TimeService.dart';

class DesafioOSI extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;

  DesafioOSI({required this.desafioIndex, required this.onComplete});

  @override
  _ChristmasTreeScreenState createState() => _ChristmasTreeScreenState();
}

class _ChristmasTreeScreenState extends State<DesafioOSI> {

  TextEditingController _controllerUserBypass = TextEditingController();
  TextEditingController _controllerPassBypass = TextEditingController();

  Color _buttonColor = Colors.blue; // Color inicial del botón
  Color _textColor = Colors.white;  // Color del texto inicial
  int _errorCount = 0; // Contador de errores
  int _errorPenalty = 0;
  bool _isTimeUp = false; // Para saber si el tiempo se agotó
  bool _isDialogOpen = false;

  // Orden de las capas del modelo OSI de mayor a menor
  final Map<String, String> correctOrder = {
    'Aplicación': 'position7',
    'Presentación': 'position6',
    'Sesión': 'position5',
    'Transporte': 'position4',
    'Red': 'position3',
    'Enlace de Datos': 'position2',
    'Física': 'position1',
  };

  // Estado inicial de los elementos arrastrados
  final Map<String, String?> draggedItems = {
    'Aplicación': null,
    'Presentación': null,
    'Sesión': null,
    'Transporte': null,
    'Red': null,
    'Enlace de Datos': null,
    'Física': null,
  };

  String? selectedLayer; // Para almacenar la capa seleccionada por toque
  String? hoveredPosition; // Para saber qué posición está siendo "resaltada" durante el arrastre
  String? selectedDraggedLayer; // Para resaltar la capa que está siendo seleccionada con un toque
   bool _isPenaltyDialogVisible = false;  // Estado del diálogo de penalización
  Timer? _penaltyTimer;  // Temporizador para el tiempo de penalización

  @override
void dispose() {
  debugPrint('El temporizador ha sido cancelado');
  _penaltyTimer?.cancel();
  super.dispose();
}

  // Función para verificar si el orden es correcto
  void checkOrder() {
    bool isCorrect = true;
    draggedItems.forEach((key, value) {
      if (correctOrder[key] != value) {
        isCorrect = false;
      }
    });

    if (isCorrect) {
      widget.onComplete();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('¡Desafío 2 Completo!'),
          content: Text('¡Increíble! Habéis descifrado el enigma de las capas y restaurado el flujo de energía en el taller de Santa. Gracias a vuestro ingenio, habéis desbloqueado un paso más en la misión para recuperar el Espíritu Navideño. ¡Seguid así, el destino de la Navidad está en vuestras manos!'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _errorCount++;
        _errorPenalty++;
      });
      showFailureSnackBar();
      if (_errorPenalty == 3 && !_isPenaltyDialogVisible) {
        _showPenaltyDialog();
      }
    }
  }

  // Función para mostrar el diálogo de penalización
  void _showPenaltyDialog() {
    _isDialogOpen = true;
    setState(() {
      _isPenaltyDialogVisible = true;
    });

    // Mostrar diálogo de penalización
    showDialog(
      context: context,
      barrierDismissible: false,  // No permite cerrar el diálogo manualmente
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
          title: Text('¡Penalización!'),
          content: Text(
            'Has cometido 3 errores. Deberás esperar 45 segundos para continuar.',
            style: TextStyle(fontSize: 18),
          ),
        ),
        ); 
        
      },
    );

    // Iniciar el temporizador de penalización de 15 segundos
    _penaltyTimer = Timer(Duration(seconds: 45), () {
      // Cerrar el diálogo de penalización después de 15 segundos
      _isDialogOpen = false;
      Navigator.of(context).pop();
      setState(() {
        _isPenaltyDialogVisible = false;
      });
      _errorPenalty = 0;  // Restablecer el contador de errores
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showChallengeDialog());
  }

  // Función para mostrar el SnackBar cuando el orden sea incorrecto
  void showFailureSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'El orden de las capas es incorrecto. Intenta nuevamente.',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red, // Fondo rojo para el error
        duration: Duration(seconds: 2), // Duración de 2 segundos
      ),
    );
  }

  // Función para colocar una capa en un contenedor organizado al tocar
  void placeLayerInContainer(String position) {
    if (selectedLayer != null) {
      setState(() {
        // Si el contenedor ya tiene un valor, reemplázalo con el nuevo
        draggedItems[selectedLayer!] = position;
        selectedLayer = null; // Resetear la capa seleccionada
      });
    }
  }

  // Función para mostrar la descripción de cada capa
  void showLayerDescription(String layer) {
    String description = '';
    switch (layer) {
      case 'Aplicación':
        description = '"Esta parte del proceso se encarga de permitir que las aplicaciones del usuario interactúen con la red. Gestiona cómo las herramientas que usamos, como los navegadores o el correo electrónico, se comunican con los servicios que permiten la transmisión de información a través de la red."';
        break;
      case 'Presentación':
        description = '"Aquí, los datos que se transmiten se ajustan para que puedan ser entendidos correctamente por el receptor, sin importar el formato en el que fueron enviados originalmente. Esta etapa también se ocupa de la compresión y, en algunos casos, de la encriptación para garantizar que la información se pueda usar de manera segura."';
        break;
      case 'Sesión':
        description = '"Se asegura de que las comunicaciones entre aplicaciones se mantengan organizadas y estructuradas. Si es necesario, puede reanudar una conversación interrumpida, asegurando que la información fluya sin problemas a lo largo del proceso."';
        break;
      case 'Transporte':
        description = '"Su tarea principal es garantizar que los datos se entreguen correctamente y de manera fiable. Divide la información en paquetes más pequeños para facilitar su envío, y se asegura de que, si un paquete se pierde, se vuelva a enviar. Además, controla la velocidad a la que se transmiten los datos."';
        break;
      case 'Red':
        description = '"Esta etapa determina el mejor camino que los datos deben seguir a través de una red para llegar a su destino. Considera la dirección de cada dispositivo y selecciona la ruta más eficiente para transmitir la información, incluso si debe pasar por varios puntos intermedios."';
        break;
      case 'Enlace de Datos':
        description = '"Aquí se asegura de que los datos lleguen de manera correcta entre dispositivos dentro de la misma red. Controla los errores de transmisión y gestiona cómo se accede a los recursos de red para enviar los datos sin conflictos."';
        break;
      case 'Física':
        description = 'Esta fase maneja la conversión de los datos a señales físicas, como electricidad o ondas de radio, que se pueden transmitir a través de cables, fibra óptica o conexiones inalámbricas. Define cómo se envían las señales y asegura que se pueda transmitir la información correctamente a través de estos medios.';
        break;
    }

    // Mostrar el diálogo con la descripción
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(description, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0)),
        actions: <Widget>[
          TextButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Mostrar el diálogo de bienvenida del desafío
  void _showChallengeDialog() {
    _isDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope( 
        canPop: false,
      child: AlertDialog(
        title: Text('¡Bienvenido al Desafío 2!'),
        content: SingleChildScrollView(  // Permite que el contenido se desplace si es largo
          child: Column(
            children: [
              Text(
                "Al avanzar en el taller, encontráis un dispositivo antiguo cubierto por capas invisibles. Cada capa representa una parte fundamental de la comunicación que conecta todos los elementos del taller de Santa. Para activar su poder y seguir adelante en vuestra misión, debéis ordenarlas correctamente, como si estuvierais resolviendo el enigma de la red que mantiene unidas las fuerzas mágicas de la Navidad. Solo con el orden correcto se abrirá el siguiente paso hacia la recuperación del Espíritu Navideño.",
                style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,  // Centrar el texto para mejor apariencia
              ),
              SizedBox(height: 10),  // Espacio entre el texto y la imagen
              Image.asset(
                'assets/images/desafio_screen/error404.gif',  // Ruta de la imagen de Papá Noel
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
                "Desafio 2",
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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco
        ),
        child: Stack(
          children: [
            // Fondo del árbol de Navidad que no se moverá
            Positioned.fill(
              child: Image.asset(
                'assets/images/desafio_screen/arbol.png', // Ruta de la imagen de fondo
                fit: BoxFit.cover, // Imagen ocupa toda la pantalla
              ),
            ),
            // Contenido principal que se desplazará si es necesario
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Espacios donde los usuarios pueden colocar las capas
                    for (int i = 7; i >= 1; i--) // Organiza de mayor a menor
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            placeLayerInContainer('position$i');
                          },
                          child: DragTarget<String>(
                            onWillAccept: (data) {
                              // Resaltar cuando un elemento se está arrastrando hacia esta posición
                              setState(() {
                                hoveredPosition = 'position$i';
                              });
                              return true;
                            },
                            onAccept: (data) {
                              setState(() {
                                // Guardamos la capa actual que ya está en esta posición antes de reemplazarla
                                String? existingLayer = draggedItems.entries
                                    .firstWhere((entry) => entry.value == 'position$i', orElse: () => MapEntry('', null))
                                    .key;

                                // Actualizamos la posición con la nueva capa arrastrada
                                draggedItems[data] = 'position$i';

                                // Si había una capa en esa posición previamente, la eliminamos de la antigua posición
                                if (existingLayer != null && existingLayer != data) {
                                  draggedItems[existingLayer] = null;
                                }
                                hoveredPosition = null; // Resetear la posición resaltada
                              });
                            },
                            onLeave: (data) {
                              setState(() {
                                hoveredPosition = null; // Resetear la posición resaltada cuando se sale
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              String layer = correctOrder.keys.toList()[7 - i];
                              bool isHovered = hoveredPosition == 'position$i'; // Verifica si esta posición está siendo resaltada

                              return Container(
                                width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho al 80% de la pantalla
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isHovered ? Colors.blue : Colors.green, // Resaltar si se está arrastrando
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        draggedItems.entries
                                                .firstWhere(
                                                  (entry) => entry.value == 'position$i',
                                                  orElse: () => MapEntry('', null),
                                                )
                                                .value != null
                                            ? draggedItems.entries
                                                .firstWhere(
                                                  (entry) => entry.value == 'position$i',
                                                  orElse: () => MapEntry('', null),
                                                )
                                                .key
                                            : 'Espacio Capa $i',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    // Botón de ayuda si se ha equivocado más de 2 veces
                                    if (_errorCount > 2)
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: IconButton(
                                          icon: Icon(Icons.help_outline, color: Colors.white),
                                          onPressed: () => showLayerDescription(layer),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    // Área donde se pueden arrastrar las capas
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Wrap(
                          spacing: 15, // Espacio entre las capas arrastrables
                          runSpacing: 15, // Espacio entre las filas de las capas
                          alignment: WrapAlignment.center,
                          children: [
                            for (String layer in draggedItems.keys) // Iterar en el orden de mayor a menor
                              Draggable<String>(
                                data: layer,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Marca la capa seleccionada para luego colocarla en un contenedor organizado
                                      selectedLayer = layer;
                                      // Resaltar el elemento tocado
                                      selectedDraggedLayer = layer;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: selectedDraggedLayer == layer
                                          ? Colors.orange // Color al estar seleccionado
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      layer, // Mostrar solo el nombre de la capa
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      layer,
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Container(),
                              ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: checkOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        elevation: 10,
                      ),
                      child: Text(
                        'Verificar Orden',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

























