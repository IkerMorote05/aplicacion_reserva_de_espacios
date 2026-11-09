class ServicioExtraDto {
  final String id;
  final String nombre;
  final String descripcion;
  final int precioCentimos;

  const ServicioExtraDto({
    required this.nombre,
    required this.id,
    required this.descripcion,
    required this.precioCentimos,
  });
}
