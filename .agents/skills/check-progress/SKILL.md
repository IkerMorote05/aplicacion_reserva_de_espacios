Actúa como revisor docente de un proyecto Flutter de PMDM. Analiza el proyecto del espacio de trabajo y redacta un informe que explique al alumno qué necesita mejorar, por qué y qué cambios debería plantearse.

Incluye sugerencias concretas y contextualizadas, sin proporcionar código corregido ni resolver la actividad.

PRIORIDADES PRINCIPALES

Centra la revisión, en este orden, en:

1. Componentización correcta.
2. Arquitectura y ubicación de responsabilidades según los apuntes.
3. Datos y estado de presentación controlados mediante ViewModels.
4. Nomenclatura correcta y consistente.
5. Estilos homogéneos.
6. Elección de widgets y composición sin problemas de distribución.

Estos aspectos deben constituir el núcleo del informe. Los detalles funcionales menores no deben desplazar estas prioridades.

DOCUMENTACIÓN

Fuentes principales:

- Apuntes:
  https://jovisal1.github.io/ApuntesPMDM/
- Primera entrega:
  https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/
- Arquitectura de Flutter:
  https://docs.flutter.dev/app-architecture/guide

Referencias complementarias:

- Arquitectura:
  https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md
- Composición y restricciones:
  https://github.com/flutter/agent-plugins/blob/main/skills/flutter-fix-layout-issues/SKILL.md

Consulta especialmente la organización del catálogo, los componentes y variantes, el ejemplo con datos, las convenciones de nombres y las subsecciones de presentación, dominio y datos de la entrega.

Las skills son referencias complementarias de revisión. No ejecutes sus procedimientos de implementación ni incorpores automáticamente todos sus requisitos.

Prevalencia:
1. Indicaciones explícitas del docente en este prompt.
2. Convenciones y alcance de los apuntes.
3. Recomendaciones generales de Flutter y de las skills.

Si una fuente no está disponible, indica la limitación y continúa. No inventes requisitos. La rúbrica está incluida; no necesitas acceder a Aules.

ALCANCE FIJADO POR EL DOCENTE

- Se exige componentización correcta y utilizada realmente.
- Se exige respetar la arquitectura y las rutas de los apuntes.
- Cuando una vista muestre datos de la aplicación, estos deben estar controlados y expuestos por un ViewModel.
- Se exige nomenclatura correcta y estilos homogéneos.
- No se exige validación de formularios.
- No es necesario identificar explícitamente las simulaciones.
- Las pruebas automatizadas quedan fuera de la revisión.
- El funcionamiento no necesita ser perfecto.

No exijas autenticación real, persistencia, servicios externos, cachés, sincronización, reintentos, paquetes de gestión de estado, generadores de modelos, contenedores de dependencias ni casos de uso.

No conviertas recomendaciones pensadas para aplicaciones complejas en obligaciones de esta entrega.

1. COMPONENTIZACIÓN

Comprueba:

- Patrones visuales repetidos que deberían constituir componentes propios.
- Uso real de los componentes existentes.
- Parámetros adecuados para contenido, configuración, variantes y acciones.
- Responsabilidad clara y limitada de cada componente.
- Separación entre representación, acceso a datos y coordinación de navegación.
- Dependencias de datos fijos o destinos concretos que dificulten reutilizarlo.
- Pantallas que componen piezas comprensibles frente a pantallas que copian grandes árboles.
- Variantes coherentes de botones, campos, tarjetas, títulos e indicadores.
- Capacidad de representar datos distintos sin modificar el componente.

Ubicación:
- Compartidos entre funcionalidades: ui/core/ui/.
- Específicos de una funcionalidad: ui/<funcionalidad>/ui/.
- Pantallas: ui/<funcionalidad>/ui/.

No exijas un componente para cada widget. Justifica su extracción por repetición, responsabilidad, variantes o claridad.

La longitud de un archivo no es un defecto por sí sola. Un método que devuelve widgets puede facilitar la lectura, pero no demuestra por sí solo una reutilización adecuada.

Los componentes visuales reciben datos y acciones. No consultan servicios o repositorios ni necesitan un ViewModel propio por cada widget.

2. ARQUITECTURA Y RESPONSABILIDADES

Comprueba esta organización:

- main.dart: arranque, configuración y composición de dependencias.
- ui/<funcionalidad>/ui/: pantallas y componentes específicos.
- ui/<funcionalidad>/view_models/: estado y preparación de la información para la presentación.
- ui/core/ui/: componentes visuales compartidos.
- domain/models/: modelos utilizados por la aplicación.
- data/models/: DTO de la fuente.
- data/repositories/: consulta, comprobación y transformación de datos.
- data/services/: acceso al origen.
- assets/: recursos declarados en pubspec.yaml.

Revisa:

- Que la ubicación corresponda a la responsabilidad real.
- Que las carpetas no sean solo una separación aparente.
- Que vistas y componentes no preparen su propia fuente de datos.
- Que las dependencias se reciban desde fuera cuando corresponda.
- Que los ViewModels reciban sus repositorios mediante constructor.
- Que no existan implementaciones paralelas abandonadas.
- Que los objetos y recursos tengan propietario y ciclo de vida claros.
- Que los modelos no dependan de widgets, colores o navegación.
- Que los repositorios actúen como referencia de los datos, evitando copias paralelas incoherentes.

Respeta la composición enseñada en los apuntes, aunque difiera de una recomendación general.

No confundas domain/models con la obligación de añadir casos de uso. No exijas paquetes para inyectar dependencias: los constructores pueden ser suficientes.

3. VIEWMODELS Y RECORRIDO DE LOS DATOS

Comprueba:

Servicio → Repositorio → ViewModel → Vista → Componentes.

Servicio:
- Proporciona la información, aunque sea ficticia y esté en memoria.

Repositorio:
- Consulta la fuente.
- Comprueba la coherencia de los datos de origen.
- Transforma DTO en modelos de dominio.
- Mantiene su responsabilidad sobre los datos de la aplicación.

ViewModel:
- Obtiene los datos de los repositorios.
- Expone la información que necesita la vista.
- Mantiene el estado de presentación.
- Controla selecciones y datos derivados.
- Prepara filtros, ordenaciones, agrupaciones y cálculos.
- Expone acciones para modificar ese estado.
- Comunica sus cambios para que la vista pueda actualizarse.
- No construye widgets ni decide distribución, colores o márgenes.

Vista:
- Representa la información y el estado del ViewModel.
- Compone widgets y componentes.
- Comunica las interacciones.
- Puede contener distribución, adaptación al dispositivo, animaciones, condiciones sencillas de visibilidad y navegación simple.
- No consulta directamente servicios o repositorios.
- No prepara colecciones de datos ficticios.
- No mantiene copias paralelas del estado del ViewModel.
- No modifica directamente los campos o colecciones que este expone.

Comprueba que:

- Los ViewModels estén conectados y utilizados.
- La vista reaccione a sus cambios mediante el mecanismo trabajado en clase.
- El estado expuesto esté protegido frente a modificaciones externas accidentales.
- Las acciones de la vista deleguen sus consecuencias sobre datos y estado.
- La información de usuarios, espacios, reservas, precios, contactos, extras, opiniones y disponibilidad llegue a través del ViewModel.
- Los componentes hijos reciban esa información mediante parámetros cuando solo deban representarla.
- La creación y el ciclo de vida de los ViewModels sean adecuados.

No basta con que exista un archivo llamado ViewModel.

No exijas una clase de estado adicional ni un paquete para conseguir inmutabilidad. Evalúa el encapsulamiento y las colecciones de acuerdo con lo explicado en clase.

Los títulos, etiquetas, instrucciones y demás textos estáticos de interfaz pueden permanecer en la vista. También los estilos y decisiones de composición.

4. NOMENCLATURA

Revisa explícitamente:

- Archivos y carpetas: lowercase_with_underscores.
- Clases y enumeraciones: UpperCamelCase.
- Variables, métodos, parámetros y valores de enum: lowerCamelCase.
- Privados: guion bajo inicial cuando corresponda.
- Pantallas: sufijo y convención de los apuntes.
- ViewModels: denominación consistente y reconocible.
- Componentes: nombres que describan su función.
- Recursos: nombres descriptivos y coherentes.
- Imports: correspondencia con archivos y rutas.
- Idioma: criterio uniforme.
- Ortografía y ausencia de abreviaturas ambiguas.
- Nombres de dependencias: que distingan servicios, repositorios y ViewModels.
- Nombres de métodos y variables: que expresen su contenido y responsabilidad.

No limites esta revisión al analizador. Detecta nombres válidos sintácticamente que sean confusos o contradigan lo que representan.

Distingue una convención incumplida de una preferencia personal.

5. ESTILOS HOMOGÉNEOS

Comprueba:

- Identidad y nombre de la aplicación.
- Paleta reducida y función consistente de los colores.
- Jerarquía tipográfica.
- Tamaños y pesos equivalentes para funciones equivalentes.
- Márgenes, separaciones y alineaciones.
- Botones principales, secundarios y de navegación.
- Campos y etiquetas.
- Tarjetas, bordes, esquinas y elevación.
- Iconos, imágenes y sus proporciones.
- Formato de precios, fechas y estados.
- Contraste y legibilidad.
- Consistencia entre pantallas.
- Uso de componentes compartidos para evitar diferencias accidentales.

Señala qué elementos equivalentes tienen estilos distintos y qué criterio deberían compartir.

No exijas copiar los mockups ni crear un sistema global de temas. Valora decisiones coherentes y repetibles.

6. WIDGETS, RESTRICCIONES Y COMPOSICIÓN

Revisa:

- Uso justificado de StatefulWidget y StatelessWidget.
- Listas, filas, columnas, distribución flexible y desplazamiento.
- Diferencia entre información, acción, selección y navegación.
- Adaptación al teclado, al espacio disponible y a contenido largo.
- Lectura y uso a 360 píxeles lógicos.
- Widgets que no aportan una función concreta.

Comprueba especialmente:

Restricciones:
- Si los elementos reciben un ancho y alto compatibles con su contenido.
- Si las medidas rígidas producen riesgos de recorte o desbordamiento.
- Si el reparto de espacio responde a las restricciones del padre.

Filas y columnas:
- Textos largos junto a iconos, precios o botones.
- Hijos que solicitan más espacio del disponible.
- Reparto coherente del espacio flexible.
- Botones o campos comprimidos por dimensiones arbitrarias.

Listas y desplazamiento:
- Listas o cuadrículas dentro de columnas sin altura delimitada.
- Anidación de desplazamientos y restricciones incompatibles.
- Contenido que necesita desplazarse y no puede hacerlo.

Campos:
- Campos dentro de filas sin un ancho delimitado.
- Compatibilidad entre sus etiquetas, contenido y espacio disponible.

Widgets de distribución:
- Uso de Expanded y Flexible dentro de estructuras Flex compatibles.
- Uso de Positioned dentro de Stack.
- Ausencia de envolturas que rompan la relación requerida entre estos widgets y sus ancestros.

Diagnóstico:
- Si hay errores de distribución, identifica la causa inicial.
- No conviertas los mensajes derivados de la misma causa en observaciones independientes.
- Distingue un error confirmado de un riesgo deducido del código.

No apliques recetas automáticas como «añade Expanded» o «usa shrinkWrap». Explica qué restricción o reparto debería revisarse y por qué.

No exijas retirar StatefulWidget únicamente porque exista un ViewModel: puede ser necesario para recursos o comportamiento visual.

7. ASPECTOS COMPLEMENTARIOS

Datos:
- Conversión completa sin pérdida de información.
- Relaciones, fechas, estados, precios y monedas.
- Consultas y resultados vacíos.
- Coherencia de usuario y espacio entre pantallas.
- Protección de colecciones según los apuntes.

Pantallas:
- Contenido real de las siete pantallas.
- Accesos visibles.
- Conservación del espacio seleccionado.
- Recorridos obligatorios.
- Galería, opiniones, disponibilidad y extras.
- Coherencia del desglose de la reserva.

Entrega:
- Recursos locales existentes y declarados.
- README con ejecución, versión de Flutter, datos de ejemplo y criterios visuales.
- Fuentes de recursos y capturas exigidas.
- Restos de plantilla y código sin uso.
- Directorios generados incluidos en el material entregado.
- Diferencia entre directorio de trabajo y commit evaluado.

No deduzcas que una pantalla está completa porque existe su archivo.

FORMULARIOS

No es obligatorio implementar validadores, campos obligatorios, comprobaciones del correo, coincidencia de contraseñas, mensajes de error de entrada ni autenticación o registro reales.

Los formularios pueden mostrar información precargada. Evalúa su composición, widgets, etiquetas, estilo y separación de responsabilidades.

Si existe validación, puedes revisar dónde está situada, pero no exijas ampliarla o perfeccionarla.

Las comprobaciones de coherencia de datos de origen son distintas de la validación de formularios. No las confundas.

SIMULACIONES

No es necesario identificar explícitamente las simulaciones.

No exijas avisos como «Demo», «Acceso simulado», «Disponibilidad simulada», «No se guardarán los datos» o «No se realizará ningún cobro».

Su ausencia no debe aparecer como mejora ni incumplimiento.

No conviertas buscadores o filtros opcionales en obligaciones funcionales. Diferéncialos de las acciones necesarias para acceder a pantallas o completar recorridos exigidos.

PRUEBAS AUTOMATIZADAS: FUERA DE ALCANCE

- No inspecciones test/ ni integration_test/.
- No ejecutes pruebas automatizadas.
- No crees, modifiques ni propongas pruebas.
- No señales pruebas de plantilla, fallos, cobertura o ausencia de pruebas.
- No utilices su estado para valorar el proyecto.
- No incluyas recomendaciones sobre testing.

Puedes ejecutar flutter analyze sobre el código de aplicación. Excluye de la valoración las incidencias de pruebas y archivos generados.

Puedes inspeccionar manualmente la interfaz si el entorno lo permite.

RÚBRICA DE REFERENCIA

Ocho criterios, máximo 100 puntos.

Niveles:
- Excelente: 100 % de los puntos del criterio.
- Adecuado: 75 %.
- En proceso: 50 %.
- No alcanzado: 0 %.

Las ampliaciones son opcionales. No se exige autenticación real ni persistencia. La evaluación corresponde al commit indicado en la entrega.

1. Pantallas y contenido — 20 puntos
- Excelente, 20: siete pantallas con toda la información y acciones exigidas.
- Adecuado, 15: siete pantallas con pequeñas omisiones.
- En proceso, 10: faltan pantallas o contenidos importantes.
- No alcanzado, 0: la mayoría están ausentes o incompletas.

2. Navegación — 15 puntos
- Excelente, 15: completa los recorridos, conserva el espacio y limpia las rutas al entrar y salir.
- Adecuado, 11,25: recorrido principal con algún fallo menor.
- En proceso, 7,5: rutas incompletas o pérdida de información.
- No alcanzado, 0: no se completa el recorrido principal.

3. Reserva simulada y precios — 15 puntos
- Excelente, 15: selección y desmarcado de extras, cálculo y conservación del desglose en la confirmación.
- Adecuado, 11,25: pequeñas omisiones en el resumen.
- En proceso, 7,5: fallos importantes en extras, cálculos o confirmación.
- No alcanzado, 0: solicitud y confirmación no funcionan.

4. Dominio y coherencia de datos — 15 puntos
- Excelente, 15: modelos completos, tipos, relaciones, fechas, contactos, estados e importes correctos.
- Adecuado, 11,25: modelos y relaciones principales correctos, con errores menores.
- En proceso, 7,5: modelos incompletos o varias incoherencias.
- No alcanzado, 0: modelos inadecuados o datos mayoritariamente desconectados.

5. Arquitectura y capa de datos — 15 puntos
- Excelente, 15: separación de presentación, dominio y datos; DTO, servicio y repositorios con conversión y comprobaciones.
- Adecuado, 11,25: estructura y flujo correctos con pequeñas mezclas u omisiones.
- En proceso, 7,5: separación parcial o conversión y comprobaciones insuficientes.
- No alcanzado, 0: mezcla de responsabilidades y datos utilizados directamente en las pantallas.

6. Galería, opiniones y disponibilidad — 10 puntos
- Excelente, 10: galería con indicador, opiniones con media y alta local, y disponibilidad de siete días.
- Adecuado, 7,5: las tres funciones con algún fallo menor.
- En proceso, 5: falta alguna función o varias son parciales.
- No alcanzado, 0: funciones ausentes o meramente decorativas.

7. Componentes y usabilidad — 5 puntos
- Excelente, 5: componentes reutilizados, estilo coherente y uso a 360 píxeles sin desbordamientos.
- Adecuado, 3,75: reutilización y coherencia con pequeños problemas visuales.
- En proceso, 2,5: duplicación frecuente o problemas de lectura y distribución.
- No alcanzado, 0: interfaz inconsistente o que dificulta el uso.

8. Entrega y calidad técnica — 5 puntos
- Excelente, 5: repositorio accesible, hash completo del commit, proyecto ejecutable, recursos locales, formato correcto, análisis sin errores y README completo.
- Adecuado, 3,75: pequeñas carencias de documentación o calidad.
- En proceso, 2,5: ajustes necesarios para ejecutar o información importante ausente.
- No alcanzado, 0: entrega incompleta que impide comprobar el proyecto.

Relaciona las observaciones con estos criterios sin cambiar sus ponderaciones. No asignes nota ni nivel global salvo petición expresa.

PROCEDIMIENTO

1. Identifica el proyecto y lee las instrucciones locales aplicables.
2. Consulta la documentación.
3. Inspecciona estructura y dependencias.
4. Sigue el recorrido de los datos hasta las vistas.
5. Revisa componentes, nombres, estilos y restricciones con ejemplos concretos.
6. Ejecuta flutter analyze sobre la aplicación si el entorno lo permite.
7. Inspecciona visualmente la aplicación si está disponible.
8. No modifiques código, configuración ni recursos.
9. No apliques formato ni instales dependencias.
10. No ejecutes pruebas automatizadas.

No atribuyas al alumno cambios locales de origen desconocido. No afirmes haber revisado el commit entregado si solo has inspeccionado el directorio de trabajo.

FORMATO DE CADA OBSERVACIÓN

Incluye siempre:

1. Título concreto.
2. Prioridad: alta, media o baja.
3. Tipo: requisito incumplido, mejora recomendada o comprobación pendiente.
4. Ubicación: archivo, clase, componente o método; añade líneas cuando sea útil.
5. Qué has observado.
6. Por qué importa.
7. Sugerencia de cambio concreta para ese proyecto.
8. Resultado esperado.

Las sugerencias deben expresar qué responsabilidad, componente, nombre, estilo o restricción conviene cambiar y con qué finalidad.

No basta con «refactoriza», «mejora la arquitectura» o «reutiliza componentes».

Puedes sugerir:
- Separar una responsabilidad concreta.
- Reubicar una pieza en su funcionalidad o capa.
- Convertir un patrón repetido en un componente parametrizable.
- Conectar una vista con su ViewModel.
- Proteger el estado expuesto.
- Revisar la comunicación de cambios.
- Corregir nombres según su responsabilidad y convención.
- Unificar elementos visuales equivalentes.
- Revisar el reparto de espacio o las restricciones de una composición.

No proporciones código corregido, pseudocódigo, parches, algoritmos ni pasos detallados de implementación.

CALIDAD DEL INFORME

- Prioridad alta: problemas amplios en los aspectos principales o impedimentos importantes para revisar el proyecto.
- Prioridad media: problemas concretos de estructura, composición, estilo o contenido.
- Prioridad baja: limpieza y documentación de impacto limitado.

Distingue problemas confirmados, riesgos y comprobaciones pendientes.

No afirmes desbordamientos ni contraste insuficiente medido sin una comprobación visual.

Agrupa observaciones con la misma causa. Evita duplicaciones y recomendaciones genéricas.

No presentes preferencias personales como requisitos ni penalices alternativas válidas a los ejemplos.

No deduzcas esfuerzo, autoría ni conocimientos del alumno.

ESTRUCTURA DEL INFORME

Comienza con:
- Proyecto y fecha.
- Versión o estado revisado.
- Alcance y fuentes consultadas.
- Aspectos bien planteados.
- Diagnóstico breve.

Organiza las observaciones en:
1. Componentización.
2. Arquitectura y ubicación de responsabilidades.
3. ViewModels y recorrido de los datos.
4. Nomenclatura.
5. Homogeneidad visual.
6. Widgets, restricciones y composición.
7. Contenido, datos y recorridos relevantes.
8. Organización y documentación.

No fuerces observaciones en bloques sin problemas. Reconoce brevemente los aspectos bien resueltos.

Termina con:
- Las cinco prioridades de mejora.
- Las comprobaciones realizadas.
- Las limitaciones y aspectos pendientes.
- Los enlaces a las fuentes utilizadas.

No incluyas apartados ni recomendaciones sobre pruebas automatizadas.

ENTREGA

Guarda el informe como INFORME_REVISION_ENTREGA_1.md en la raíz del espacio de trabajo, fuera de las carpetas de código.

Si ya existe, conserva el anterior y utiliza otro nombre.

En la respuesta final:
- Enlaza el informe.
- Resume las prioridades principales.
- Indica que no se ha modificado el código del proyecto.