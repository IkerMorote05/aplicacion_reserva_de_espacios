class ComentarioDto {
  final String id;
  final String espacioId;
  final String autorId;
  int puntuacion;
  final String texto;
  final String fechaIso;

  ComentarioDto({
    required this.id,
    required this.espacioId,
    required this.autorId,
    required this.puntuacion,
    required this.texto,
    required this.fechaIso,
  }) {
    if (puntuacion >= 1 && puntuacion <= 5) {
      puntuacion = puntuacion;
    }
  }
}
