import 'dart:async';
import 'package:christmas_project/MainPage/Desafio10.dart';
import 'package:christmas_project/MainPage/Desafio2Screen.dart';
import 'package:christmas_project/MainPage/DesafioCaminoQR.dart';
import 'package:christmas_project/MainPage/DesafioCofreCerrado.dart';
import 'package:christmas_project/MainPage/DesafioCrucigrama.dart';
import 'package:christmas_project/MainPage/DesafioLockScreen.dart';
import 'package:christmas_project/MainPage/DesafioOSI.dart';
import 'package:christmas_project/MainPage/DesafioPKT.dart';
import 'package:christmas_project/MainPage/DesafioSQL.dart';
import 'package:christmas_project/MainPage/DesafioScreen.dart';
import 'package:christmas_project/Timer_Tools/TimeService.dart';
import 'package:christmas_project/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver{
  List<bool> desafios = List.generate(10, (index) => index == 0);
  List<bool> desafios_Completados = List.generate(10, (index) => true);
  
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observar el ciclo de vida de la app
    // Accedemos al TimerService para iniciar el temporizador automáticamente
    final timerService = Provider.of<TimerService>(context, listen: false);
    
    // Iniciamos el temporizador automáticamente cuando se carga la pantalla
    if (!timerService.isTimerRunning) {
      timerService.startTimer(
        (totalSeconds) {
          setState(() {}); // Actualizamos la pantalla cada vez que el temporizador cambie
        },
        () {
          setState(() {
            // El temporizador ha terminado
          });
        },
      );
    }
  }

  @override
  void dispose() {
    // Elimina el observador cuando el widget se dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  

  void completarDesafio(int index) {
    setState(() {
      if (index < desafios.length - 1) {
        desafios[index + 1] = true;
        desafios_Completados[index] = false;
      }
    });
  }
   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timerService = Provider.of<TimerService>(context, listen: false);

    if (state == AppLifecycleState.resumed) {
      // La app ha sido reanudada
    } else if (state == AppLifecycleState.paused) {
      // La app está en segundo plano (no es necesario detener el temporizador aquí)
    }
  }

  int contarDesafiosCompletados() {
  int completados = 0;

  for (int i = 0; i < desafios.length; i++) {
    if (desafios[i] && !desafios_Completados[i]) {
      completados++;
    }
  }

  return completados;
}


  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,  // Fondo rojo
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,  // Alineamos todo hacia la izquierda
              children: [
                // Título
                Text(
                  'Desafío Navideño',
                  style: TextStyle(color: Colors.white),  // Texto blanco
                ),
                // Espaciado entre el título y el contador
                SizedBox(width: 100),  // Añade un pequeño espacio entre el texto y el contador
                // Contador
                Consumer<TimerService>(
                  builder: (context, timerService, child) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),  // Añadir padding al contador
                      decoration: BoxDecoration(
                        color: timerService.isTimeUp ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        timerService.formatTime(timerService.totalSeconds),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        body: PopScope(
          canPop: false,
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos columnas para las tarjetas
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/home_screen/Icono_regalo.png'),
                      fit: BoxFit.cover, // Ajusta la imagen para cubrir toda el área del container
                    ),
                  ),
                  child: InkWell(
                    onTap: desafios[index] && desafios_Completados[index]
                        ? () {
                          switch (index){
                            case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioCofreCerrado(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            );
                            case 1:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioOSI(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            );
                            case 2:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioSQL(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            );
                            case 3:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LockScreen(
                                  desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            );
                            case 4:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioCaminoQR(
                                 desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            ); 
                            case 5:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesafioPKTScreen(
                                 desafioIndex: index,
                                  onComplete: () => completarDesafio(index),

                                ),
                              ),
                            ); 
                            case 6:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Desafio2Screen(
                                 desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            ); 
                            case 7:
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SopaDeLetrasScreen(
                                 desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            );
                            case 8:
                               Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Desafio1(
                                 desafioIndex: index,
                                  onComplete: () => completarDesafio(index),
                                ),
                              ),
                            );
                            case 9:
                               Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FelicitacionScreen(
                                  totalSeconds: timerService.totalSeconds,
                                ),
                              ),
                            );
                          }
                          }
                        : desafios[index] && !desafios_Completados[index] ? null:null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: desafios[index] && !desafios_Completados[index] ? Colors.green : desafios[index] && desafios_Completados[index] ? Colors.yellow : Colors.grey,
                          ),
                          child: desafios[index] && !desafios_Completados[index]
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 40,
                                )
                                : desafios[index] && desafios_Completados[index] ?
                                Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                  size: 40,
                                ) 
                              : null,
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(3),
                          child: Text(
                            'Desafío ${index + 1}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ),
        floatingActionButton: timerService.isTimeUp
        ? Stack(
            children: [
              // ModalBarrier para bloquear interacción
              ModalBarrier(
                dismissible: false, // Bloquea la interacción
                color: Colors.black.withOpacity(0.7), // Color de la capa
              ),
              // Mostrar el AlertDialog cuando el tiempo se haya agotado
              Center(
                child: AlertDialog(
                  title: Text("¡Tiempo agotado!", style: TextStyle(fontSize: 30.0)),
                  content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "El tiempo ha terminado. No habéis podido salvar la navidad.\n",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Container(
                        alignment: Alignment.center,  // Centra el contenido dentro del container
                        padding: EdgeInsets.all(16.0),  // Ajusta el padding si lo necesitas
                        child: Image.asset(
                          'assets/images/desafio_screen/reno.gif',  // Ruta del GIF en tus activos
                          width: 150,  // Ancho del GIF
                          height: 150, // Alto del GIF
                          fit: BoxFit.contain, // Ajuste de la imagen
                        ),
                      ),
                      Text("Detalles de Participación",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                      Text(
                        "Tiempo Empleado: 1:00 Hora",
                        style: TextStyle(fontSize: 20.0),
                      ),
                       Text(
                        "Desafíos Completados: ${contarDesafiosCompletados()}/10",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // No hay acción para cerrar, este botón solo sirve para mostrar el mensaje
                      },
                      child: Text("Aceptar"),
                    ),
                  ],
                ),
              ),
            ],
          )
        : null,  // Si el tiempo no ha terminado, no mostramos nada
      );
      
  }
}