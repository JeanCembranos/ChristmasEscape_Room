import 'dart:async';
import 'package:flutter/material.dart';

class TimerService with ChangeNotifier {
  static final TimerService _singleton = TimerService._internal();

  factory TimerService() {
    return _singleton;
  }

  TimerService._internal();

  int totalSeconds = 3600; // Tiempo de 1 hora en segundos (ajustable)
  Timer? _timer;
  bool isTimeUp = false;
  bool _isTimerRunning = false;

  bool get isTimerRunning => _isTimerRunning;

  void startTimer(Function onTick, Function onTimeUp) {
    if (_isTimerRunning) return; // No iniciar un nuevo temporizador si ya está en ejecución

    _isTimerRunning = true;  // Marcamos que el temporizador está corriendo
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (totalSeconds > 0) {
        totalSeconds--;
        onTick(totalSeconds);
        notifyListeners(); // Notificamos para que la UI se actualice
      } else {
        isTimeUp = true;
        onTimeUp();
        cancelTimer();
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
    _isTimerRunning = false;  // Cuando se cancela, permitimos reiniciar el temporizador
    notifyListeners(); 
  }

  int Tiempo_final(){
    return totalSeconds;
  }

  String formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}