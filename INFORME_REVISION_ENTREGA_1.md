# Informe de revisión — Entrega 1

## Proyecto y fecha

- **Proyecto:** `aplicacion_reserva_espacios`.
- **Fecha:** 13 de noviembre de 2026.
- **Versión técnica del entorno:** Flutter 3.47.4 estable y Dart 3.13.3.
- **Estado revisado:** árbol de trabajo actual, con `HEAD` en `0e195f258c0ff4ce2e731ff7085b72b6598bc61b`. No se indicó un commit de entrega.
- **Alcance:** revisión estática de presentación, dominio, datos, recursos, documentación y organización del proyecto. El árbol contiene modificaciones locales en `lib/ui/core/ui/reserva_tarjeta.dart` y `lib/ui/reservas/ui/mis_reservas_screen.dart`, además de `.agents/skills/check-progress/` sin seguimiento. No se atribuye su autoría; los hallazgos describen el contenido observado.
- **Fuentes consultadas:** apuntes de Entrega 1, sus subsecciones de presentación, datos y dominio, el ejemplo de ViewModel y las guías de arquitectura de Flutter indicadas al final.

## Aspectos bien planteados

- La estructura general separa `ui`, `domain/models` y `data`, y existen DTO, un servicio local y repositorios.
- Los modelos de dominio representan entidades y relaciones básicas; el dominio no importa Flutter.
- El servicio protege sus colecciones principales con `List.unmodifiable`.
- Hay seis espacios, reservas relacionadas con IDs de usuario y espacio, contactos, extras y datos de disponibilidad generados para siete días.
- `NuevaReservaScreen` tiene una composición por pasos, selección local de día y franja, y usa componentes compartidos para algunos botones y estados vacíos.
- `MisReservasScreen` usa actualmente una lista desplazable como contenedor. No se observa en su árbol actual el problema anterior de una lista vertical anidada dentro de `ListBody`.
- `.gitignore` excluye `build/` y `.dart_tool/`.

## Diagnóstico breve

La base de datos ficticios y parte de la interfaz están presentes, pero el recorrido principal está incompleto: el detalle lanza `UnimplementedError`, el perfil está vacío y la nueva reserva termina en un resumen con la acción final deshabilitada. Además, varias pantallas consultan sus propios repositorios en vez de recibir estado preparado, y hay errores en conversiones que impiden mostrar correctamente imágenes, extras, comentarios y estados. Por ello, la presencia de archivos y modelos no equivale todavía a una entrega navegable de principio a fin.

## 1. Componentización

### 1.1 Las tarjetas compartidas consultan datos y deciden navegación

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `lib/ui/core/ui/espacio_targeta.dart` (`EspacioTargeta`) y `lib/ui/core/ui/reserva_tarjeta.dart` (`ReservaTarjeta`).
- **Qué se observó:** ambas tarjetas crean un servicio y repositorios propios y buscan el objeto por ID durante `build`. `EspacioTargeta` también decide el destino de navegación. En la tarjeta de espacio hay dos botones con el mismo texto; uno no tiene acción. En la tarjeta de reserva, «Ver detalle» tampoco tiene acción.
- **Por qué importa:** `core/ui` contiene piezas que deberían representar los datos que reciben. La tarjeta queda acoplada a los datos demo y a destinos concretos, duplica la preparación de datos y no puede representar fácilmente otra fuente o variante.
- **Sugerencia:** hacer que la pantalla o su ViewModel obtenga el modelo una vez y que las tarjetas reciban ese modelo y las acciones necesarias mediante parámetros. Revisar también si cada tarjeta necesita dos acciones distintas y darles etiquetas diferenciadas.
- **Resultado esperado:** las tarjetas representan datos distintos sin crear servicios/repositorios ni controlar rutas por sí mismas.

## 2. Arquitectura y ubicación de responsabilidades

### 2.1 El servicio global de `main.dart` no es la fuente usada por las pantallas

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `lib/main.dart` y las pantallas de `ui/acceso`, `ui/espacios` y `ui/reservas`.
- **Qué se observó:** `main.dart` construye un `DatosSimuladosService`, pero las pantallas vuelven a crear servicios y repositorios con las mismas colecciones. `EspaciosScreen`, por ejemplo, crea un servicio con listas vacías para entidades que no utiliza.
- **Por qué importa:** existe una composición aparente en el arranque, pero no es la que alimenta las vistas. Las dependencias y el ciclo de vida de los datos quedan repartidos por la interfaz.
- **Sugerencia:** elegir un único punto de composición para servicios y repositorios y hacer que las pantallas o ViewModels reciban las dependencias que usan, siguiendo el patrón por constructores de los apuntes.
- **Resultado esperado:** un recorrido de datos reconocible desde el origen hasta la interfaz, sin instancias paralelas innecesarias.

## 3. ViewModels y recorrido de los datos

### 3.1 Las pantallas preparan datos y estado sin ViewModels conectados

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `homePantalla.dart`, `espacios_screen.dart`, `nueva_reserva_screen.dart` y `mis_reservas_screen.dart`; único ViewModel existente en `ui/acceso/view_models/login_viewmodel.dart`.
- **Qué se observó:** las pantallas construyen servicios/repositorios y obtienen sus listas directamente. `NuevaReservaScreen` conserva la selección de espacio, día, franja y paso, y calcula duración e importes dentro de la vista. `LoginViewmodel` no está conectado a `LoginScreen`; sus campos de nombre y correo son finales y `login()` devuelve `null` incluso cuando encuentra un usuario.
- **Por qué importa:** no se cumple el recorrido servicio → repositorio → ViewModel → vista. Tampoco hay una fuente única para el estado y los datos que representan las pantallas.
- **Sugerencia:** asignar a ViewModels de las funcionalidades la consulta a repositorios, los datos visibles, las selecciones y los cálculos de presentación; conectar las vistas a sus cambios y dejar en ellas la composición y las interacciones visuales. Completar o retirar la implementación paralela del ViewModel de login.
- **Resultado esperado:** las vistas muestran estado preparado y delegan las operaciones de datos y presentación al ViewModel.

### 3.2 Los componentes tampoco reciben el estado preparado

- **Prioridad:** media.
- **Tipo:** mejora recomendada.
- **Ubicación:** `EspacioTargeta`, `ReservaTarjeta`, `Homepantalla` y `MisReservasScreen`.
- **Qué se observó:** las tarjetas vuelven a consultar datos por ID, mientras que las pantallas conservan listas propias. `Homepantalla` además prepara repositorios de reservas y comentarios que no utiliza.
- **Por qué importa:** hay fuentes de datos y responsabilidades duplicadas; las pantallas y tarjetas pueden mostrar información distinta aunque partan del mismo catálogo.
- **Sugerencia:** mantener la preparación de datos en el ViewModel de cada pantalla y pasar a cada componente solo el modelo que representa y sus callbacks.
- **Resultado esperado:** las tarjetas se mantienen reutilizables y los datos mostrados son coherentes en todo el recorrido.

## 4. Nomenclatura

### 4.1 Archivos e identificadores no siguen una convención uniforme

- **Prioridad:** media.
- **Tipo:** requisito incumplido.
- **Ubicación:** `lib/ui/acceso/ui/homePantalla.dart`, `lib/ui/core/ui/barraNavegacion.dart`, `login_viewmodel.dart`, `mis_reservas_screen.dart`, `reserva_dto.dart` y `datos_demo.dart`.
- **Qué se observó:** hay archivos en camelCase en lugar de `lowercase_with_underscores`; `Homepantalla` no sigue la convención de clase de pantalla usada en el resto; `_MisReservasScreemState` contiene una errata; `LoginViewmodel` no mantiene la capitalización de `ViewModel`. Los valores `PEND`, `CONF`, `CAND` y constantes como `e1_limpieza` tampoco siguen lowerCamelCase. El parámetro `espacioid` cambia el patrón de nombres.
- **Por qué importa:** dificulta localizar pantallas y entender si un nombre es clase, valor de fuente o variable. El analizador confirma varios de estos avisos.
- **Sugerencia:** aplicar las convenciones de nombres del enunciado al renombrar archivos, clases, miembros y valores; mantener los códigos de fuente diferenciados de los nombres de dominio.
- **Resultado esperado:** imports, clases y miembros describen su función con una convención consistente.

## 5. Homogeneidad visual

### 5.1 La aplicación mezcla estilos equivalentes

- **Prioridad:** media.
- **Tipo:** mejora recomendada.
- **Ubicación:** `login_screen.dart`, `registro_screen.dart`, `homePantalla.dart`, `espacio_targeta.dart`, `reserva_tarjeta.dart` y `nueva_reserva_screen.dart`.
- **Qué se observó:** conviven indigo, negro, grises y el morado de la nueva reserva; títulos y botones equivalentes usan tamaños, pesos, rellenos y formas distintos. `ReservaTarjeta` muestra todos los estados en verde y presenta el valor del enum directamente, sin convertirlo a una etiqueta legible.
- **Por qué importa:** el significado de color y jerarquía cambia entre pantallas y un estado puede no distinguirse correctamente.
- **Sugerencia:** acordar una paleta breve y criterios comunes para títulos, acciones principales/secundarias, tarjetas y etiquetas de estado; representar cada estado con texto y un estilo consistente, no solo con color.
- **Resultado esperado:** las acciones y estados equivalentes se reconocen de la misma manera en el conjunto de pantallas.

## 6. Widgets, restricciones y composición

### 6.1 Hay filas con controles de ancho rígido que conviene comprobar en móvil

- **Prioridad:** media.
- **Tipo:** comprobación pendiente.
- **Ubicación:** `homePantalla.dart` (fila de categorías) y `espacio_targeta.dart` (fila de acciones).
- **Qué se observó:** los tres botones de categorías reciben 105 píxeles cada uno; el último contiene la etiqueta más larga. La tarjeta de espacio coloca dos botones con textos largos e idénticos en una sola fila. No se hizo una comprobación visual en un dispositivo de 360 píxeles lógicos.
- **Por qué importa:** el ancho interior disponible depende de los márgenes de la pantalla y de la tarjeta; las etiquetas podrían ajustarse a varias líneas o quedar comprimidas.
- **Sugerencia:** revisar el reparto de ancho y la composición de esas filas en 360 píxeles, usando el texto real de cada acción para decidir si conviene ajustar el reparto o mostrar las acciones de otra forma.
- **Resultado esperado:** nombres y botones se leen completos sin desbordamientos ni compresión excesiva.

## 7. Contenido, datos y recorridos relevantes

### 7.1 Detalle y perfil no están implementados; el recorrido principal se interrumpe

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `lib/ui/espacios/ui/espacio_detalle_screen.dart`, `lib/ui/perfil/ui/perfil_screen.dart`, `EspacioTargeta` y `Barranavegacion`.
- **Qué se observó:** `EspacioDetalleScreen.build` lanza `UnimplementedError`, aunque `EspacioTargeta` navega a esa pantalla sin pasar el espacio seleccionado. `perfil_screen.dart` está vacío y no hay destino Perfil en la barra inferior.
- **Por qué importa:** el detalle y el perfil son pantallas mínimas; además, falla el recorrido catálogo → detalle y faltan accesos principales solicitados.
- **Sugerencia:** completar ambas pantallas con la información requerida, pasar el espacio elegido al detalle y añadir el acceso a Perfil dentro del mismo patrón de navegación de las secciones principales.
- **Resultado esperado:** se pueden consultar espacios distintos y recorrer Inicio, Mis reservas y Perfil sin encontrar una pantalla vacía o una excepción.

### 7.2 La nueva reserva no llega a una confirmación ni conserva el desglose exigido

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `lib/ui/reservas/ui/nueva_reserva_screen.dart` (`_contenidoResumen`, `_totalCentimos` y acción inferior).
- **Qué se observó:** la pantalla selecciona espacio y franja y muestra un total de alquiler, pero no presenta selección de extras, actividad, asistentes, subtotales ni contacto del local. La acción final muestra «Continuar · No disponible» y está deshabilitada; no hay confirmación que reciba el mismo espacio y desglose.
- **Por qué importa:** el recorrido exigido se detiene antes de confirmar y no permite comprobar la coherencia del precio con servicios contratados.
- **Sugerencia:** completar la solicitud con los datos y opciones requeridos, recalcular el desglose a partir de las selecciones y hacer que la confirmación simulada reciba la misma información.
- **Resultado esperado:** el usuario puede completar el flujo y revisar un resumen coherente sin modificar la fuente demo.

### 7.3 Mis reservas no distingue próximas, históricas ni usuario

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `mis_reservas_screen.dart`, `ReservaTarjeta` y `ReservasRepository.obtenerPorUsuario`.
- **Qué se observó:** la pantalla usa `obtenerTodos()` y el botón «Próximas» cuenta todas las reservas; incluye fechas anteriores al 13 de noviembre de 2026. «Historial» no tiene acción. La tarjeta no muestra actividad, fecha completa, asistentes, extras ni contacto del local. El login no entrega un usuario a la pantalla. Además, `obtenerPorUsuario` crea una lista no modificable y luego intenta añadir coincidencias, lo que puede fallar en ejecución.
- **Por qué importa:** la pantalla no representa «mis» reservas ni cumple el contenido mínimo para comparar estados y consultar la reserva.
- **Sugerencia:** definir el usuario de demostración que verá la pantalla, delegar la separación entre próximas e históricas y sus contadores al ViewModel, y preparar la tarjeta con todos los datos relacionados. Corregir también la construcción del resultado del repositorio para que admita coincidencias.
- **Resultado esperado:** cada pestaña muestra el subconjunto correcto, con datos completos y sin errores al filtrar.

### 7.4 Las conversiones de dominio pierden o transforman mal datos

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `espacios_repository.dart`, `reservas_repository.dart`, `comentarios_repository.dart` y `reserva_dto.dart`.
- **Qué se observó:** la conversión de espacio reemplaza `imagenesAssets` y `serviciosDisponibles` por listas vacías y no copia `sitioWeb`. `ComentariosRepository.obtenerPorEspacio` mapea cada comentario a un booleano en vez de devolver los comentarios. `ReservasRepository.obtenerEstado` compara el enum `CodigoEstado` con cadenas; el analizador señala tipos incompatibles, por lo que las ramas de confirmado y pendiente no pueden coincidir. Las relaciones de reserva y comentario son nullable y no se rechazan referencias inexistentes.
- **Por qué importa:** se pierden justo los datos que necesita el detalle y la reserva; las opiniones no se pueden consumir como comentarios y los estados no se muestran conforme a la fuente.
- **Sugerencia:** completar cada conversión conservando todos los campos del DTO; filtrar objetos de comentario, no predicados; mapear cada valor de estado del enum a su estado de dominio y tratar explícitamente códigos y relaciones desconocidos.
- **Resultado esperado:** dominio, tarjetas y resumen conservan imágenes, servicios, relaciones, comentarios y estados de forma coherente.

### 7.5 Las rutas de imágenes de los espacios no existen en los recursos incluidos

- **Prioridad:** alta.
- **Tipo:** requisito incumplido.
- **Ubicación:** `lib/data/services/datos_demo.dart`, `lib/ui/core/ui/espacio_targeta.dart`, `pubspec.yaml` y `assets/images/`.
- **Qué se observó:** los seis espacios referencian imágenes como `sala_agora.png`, `patio_llum.png` y variantes de galería, pero `assets/images/` solo contiene `loginImagen.webp` y tres imágenes `salonPrueba*.png`. La carpeta sí está declarada en `pubspec.yaml`; declarar el directorio no crea los archivos ausentes.
- **Por qué importa:** las tarjetas no pueden mostrar las imágenes asociadas y la galería requerida no tiene recursos locales disponibles.
- **Sugerencia:** incorporar los archivos de imagen referenciados o alinear las rutas demo con recursos existentes; documentar su procedencia junto con las capturas requeridas.
- **Resultado esperado:** cada espacio carga sus imágenes locales y la galería puede variar según el espacio.

### 7.6 El acceso no conserva la identidad del usuario y faltan elementos de las pantallas de acceso

- **Prioridad:** media.
- **Tipo:** requisito incumplido.
- **Ubicación:** `login_screen.dart`, `registro_screen.dart`, `LoginViewmodel` y `DatosDemo`.
- **Qué se observó:** el login busca un usuario por nombre y correo, pero al navegar no conserva ni comunica ese usuario. La pantalla no muestra contraseña ni opciones sociales descritas en la presentación. Registro permite ir directamente a Home y no ofrece un retorno visible al login dentro de la pantalla.
- **Por qué importa:** no se mantiene una identidad ficticia coherente entre acceso, perfil y reservas, y los recorridos Login ↔ Registro quedan incompletos.
- **Sugerencia:** mantener un usuario de demostración coherente durante el recorrido y completar los campos, accesos y retorno entre pantallas que describe la presentación. No hace falta autenticación real.
- **Resultado esperado:** el acceso simulado lleva a las pantallas esperadas y el usuario mostrado corresponde a las reservas consultadas.

### 7.7 El repositorio de comentarios acepta una puntuación sin corregirla ni rechazarla

- **Prioridad:** baja.
- **Tipo:** mejora recomendada.
- **Ubicación:** `comentario_dto.dart` y `domain/models/comentario.dart`.
- **Qué se observó:** `ComentarioDto.puntuacion` es mutable y su constructor no corrige valores fuera de rango; el constructor de dominio asigna el mismo valor cuando es válido y limita silenciosamente el resto.
- **Por qué importa:** el DTO puede cambiar después de crearse y una fuente inválida puede convertirse en una puntuación distinta sin dejar constancia del error de datos.
- **Sugerencia:** proteger la puntuación del DTO y validar explícitamente que la fuente está en el rango permitido, siguiendo la comprobación de coherencia de datos indicada en los apuntes.
- **Resultado esperado:** las opiniones conservan valores válidos y los datos ficticios incoherentes se detectan en su origen.

## 8. Organización y documentación

### 8.1 El README sigue siendo la plantilla de Flutter

- **Prioridad:** baja.
- **Tipo:** requisito incumplido.
- **Ubicación:** `README.md` y raíz del proyecto.
- **Qué se observó:** el README solo contiene el texto genérico de inicio de Flutter. No documenta cómo ejecutar esta aplicación, la versión usada, los datos demo, los criterios visuales ni las fuentes de imágenes. No se encontraron capturas de las pantallas.
- **Por qué importa:** la entrega no explica cómo comprobar el recorrido ni permite reconocer las decisiones visuales y los recursos empleados.
- **Sugerencia:** sustituir el texto de plantilla por instrucciones de ejecución, versión de Flutter, descripción de datos demo, criterios visuales y procedencia de recursos; añadir las capturas solicitadas.
- **Resultado esperado:** otra persona puede ejecutar y revisar la entrega con información suficiente.

## Cinco prioridades de mejora

1. Implementar el detalle y Perfil, conectarlos a la navegación y conservar el espacio seleccionado.
2. Completar el recorrido de nueva reserva hasta la confirmación simulada con extras y desglose.
3. Conectar pantallas y componentes con ViewModels y evitar que los componentes creen sus propios repositorios.
4. Corregir las conversiones de espacios, comentarios, estados y consultas de reservas por usuario.
5. Incorporar las imágenes referenciadas y unificar la información y los estilos de las tarjetas.

## Comprobaciones realizadas

- Inspección estática de las pantallas, componentes compartidos, ViewModel, modelos, DTO, servicio, repositorios, recursos, `pubspec.yaml`, `README.md` y estado de Git.
- `flutter analyze` no llegó a producir un resultado: el servidor de análisis terminó con `FormatException` al interpretar un mensaje LSP.
- Como alternativa, `dart analyze lib` terminó con 30 diagnósticos (avisos e información, sin diagnósticos de tipo error). Entre ellos aparecen comparaciones de tipos incompatibles en la conversión de estados, nombres fuera de convención y campos/imports sin uso.
- No se hizo comprobación visual en un dispositivo; las observaciones sobre distribución se marcan como riesgos o comprobaciones pendientes, no como desbordamientos confirmados.
- El informe describe el árbol de trabajo observado y no afirma que corresponda al commit evaluado.
- No se modificó el código de la aplicación.

## Limitaciones y aspectos pendientes

- No se indicó el hash del commit que se entregará; el contenido revisado incluye cambios locales de origen no atribuido.
- La revisión visual a 360 píxeles y la comprobación de los recursos en ejecución quedan pendientes.

## Fuentes consultadas

- [Apuntes PMDM — Entrega 1](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/)
- [Capa de presentación y requisitos de pantallas](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/presentacion/)
- [Capa de datos](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/datos/)
- [Capa de dominio](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/dominio/)
- [Ejemplo con datos: ViewModel, pantalla y catálogo](https://jovisal1.github.io/ApuntesPMDM/widgets/ejemplo-con-datos/pantalla-y-estado/)
- [Guía de arquitectura de Flutter](https://docs.flutter.dev/app-architecture/guide)
- [Referencia complementaria: arquitectura Flutter](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md)
- [Referencia complementaria: restricciones y errores de layout](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-fix-layout-issues/SKILL.md)
