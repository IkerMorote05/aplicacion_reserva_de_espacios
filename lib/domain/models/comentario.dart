import 'package:aplicacion_reserva_espacios/domain/models/usuario.dart';

class Comentario {
  final String id;
  final String espacioId;
  final Usuario autor;
  int puntuacion;
  final String texto;
  final DateTime fecha;

  Comentario({
    required this.id,
    required this.espacioId,
    required this.autor,
    required this.puntuacion,
    required this.texto,
    required this.fecha,
  }) {
    if (puntuacion >= 1 && puntuacion <= 5) {
      this.puntuacion = puntuacion;
    } else {
      if (puntuacion < 1) {
        this.puntuacion = 1;
      } else {
        this.puntuacion = 5;
      }
    }
  }
}
