import 'package:aplicacion_reserva_espacios/data/models/contacto_local_dto.dart';
import 'package:aplicacion_reserva_espacios/data/models/servicio_extra_dto.dart';

class EspacioDto {
  final String id;
  final String nombre;
  final String descripcion;
  final String ubicacion;
  final String horario;
  final String condicionesUso;
  final int aforo;
  final String imagenAsset;
  final List<String> imagenesAssets;
  final String? sitioWeb;
  final List<ServicioExtraDto> serviciosDisponibles;
  final List<String> actividades;
  final List<String> equipamiento;
  final int precioHoraCentimos;
  final String moneda;
  final ContactoLocalDto contacto;

  const EspacioDto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.horario,
    required this.condicionesUso,
    required this.imagenAsset,
    required this.moneda,
    required this.aforo,
    required this.precioHoraCentimos,
    required this.actividades,
    required this.equipamiento,
    required this.contacto,
    required this.imagenesAssets,
    this.sitioWeb,
    required this.serviciosDisponibles,
  });
}
