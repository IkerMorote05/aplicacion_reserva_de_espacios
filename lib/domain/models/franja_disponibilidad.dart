class FranjaDisponibilidad {
  final DateTime inicio;
  final DateTime fin;
  final bool disponible;

  FranjaDisponibilidad({
    required this.inicio,
    required this.fin,
    this.disponible = true,
  });
}
