import 'dart:async';
import 'package:flutter/material.dart';

class DesafioOSI extends StatefulWidget {
  final int desafioIndex;
  final VoidCallback onComplete;
  final int totalSeconds;
  Timer? timer;

  DesafioOSI({required this.desafioIndex, required this.onComplete, required this.timer, required this.totalSeconds});

  @override
  _ChristmasTreeScreenState createState() => _ChristmasTreeScreenState();
}

class _ChristmasTreeScreenState extends State<DesafioOSI> {
  Color _buttonColor = Colors.blue; // Color inicial del botón
  Color _textColor = Colors.white;  // Color del texto inicial

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
          title: Text('¡Felicidades!'),
          content: Text('¡Has organizado correctamente las capas del OSI!'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      showFailureSnackBar();
    }
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
        description = 'La capa final donde las herramientas y servicios que usamos entran en acción...';
        break;
      case 'Presentación':
        description = 'Esta capa se encarga de traducir y formatear los datos...';
        break;
      case 'Sesión':
        description = 'Mantiene el orden en la conversación digital...';
        break;
      case 'Transporte':
        description = 'Organiza y coordina la entrega de datos...';
        break;
      case 'Red':
        description = 'Encuentra el mejor camino para que los datos viajen...';
        break;
      case 'Enlace de Datos':
        description = 'Garantiza que los datos lleguen intactos en trayectos cortos...';
        break;
      case 'Física':
        description = 'Asegura que la información fluya correctamente entre dispositivos...';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desafío OSI', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red, // AppBar rojo con texto blanco
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
                                draggedItems[data] = 'position$i';
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



