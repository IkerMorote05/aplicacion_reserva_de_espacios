import 'package:flutter/material.dart';

abstract final class TemaApp {
  static const Color fondo = Color(0xfff7efe5);
  static const Color superficie = Colors.white;
  static const Color superficieAtenuada = Color(0xffefe3d4);
  static const Color tinta = Color(0xff1f2332);
  static const Color textoSecundario = Color(0xff6e635b);
  static const Color borde = Color(0xffeadbc8);

  static const Color acento = Color.fromARGB(255, 36, 130, 207);
  static const Color acentoSuave = Color(0xfffde4d8);

  static const Color acentoTexto = Color(0xffb23a14);
  static const Color sol = Color(0xfff6c453);
  static const Color azul = Color(0xff4c7fd9);

  static const Color solSuave = Color(0xfffff1cc);
  static const Color azulSuave = Color(0xffe4ecfa);

  static const Color exito = Color(0xff267a4c);
  static const Color aviso = Color(0xff9a5b00);
  static const Color error = Color(0xffc8402c);

  static const Color sombra = Color(0x338a5a3c);

  static const double radio = 20;
  static const double radioControl = 16;

  static const String fuente = 'Montserrat';

  static ThemeData crear() {
    final esquema =
        ColorScheme.fromSeed(
          seedColor: acento,
          brightness: Brightness.light,
        ).copyWith(
          primary: acento,
          onPrimary: Colors.white,
          primaryContainer: acentoSuave,
          surface: fondo,
          onSurface: tinta,
          onSurfaceVariant: textoSecundario,
          surfaceContainerHighest: superficie,
          outline: borde,
          outlineVariant: borde,
          error: error,
        );
    const pildora = StadiumBorder();
    const textoBoton = TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700);
    const tamanoBoton = Size.fromHeight(54);

    return ThemeData(
      useMaterial3: true,
      fontFamily: fuente,
      colorScheme: esquema,
      scaffoldBackgroundColor: fondo,
      dividerTheme: const DividerThemeData(color: borde, space: 24),
      appBarTheme: const AppBarTheme(
        backgroundColor: fondo,
        surfaceTintColor: Colors.transparent,
        foregroundColor: tinta,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: tinta,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: superficie,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: sombra,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radio),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: superficie,
        indicatorColor: acentoSuave,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? acento
                : textoSecundario,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => TextStyle(
            color: estados.contains(WidgetState.selected)
                ? acento
                : textoSecundario,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: const WidgetStatePropertyAll(superficie),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        side: const WidgetStatePropertyAll(BorderSide(color: borde)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radioControl),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tinta,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xffbdb3aa),
          disabledForegroundColor: Colors.white,
          minimumSize: tamanoBoton,
          shape: pildora,
          textStyle: textoBoton,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: superficie,
          foregroundColor: tinta,
          side: const BorderSide(color: borde),
          minimumSize: tamanoBoton,
          shape: pildora,
          textStyle: textoBoton,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tinta,
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: superficie,
        labelStyle: const TextStyle(color: textoSecundario),
        floatingLabelStyle: const TextStyle(color: textoSecundario),
        prefixIconColor: textoSecundario,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radioControl),
          borderSide: const BorderSide(color: borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radioControl),
          borderSide: const BorderSide(color: borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radioControl),
          borderSide: const BorderSide(color: acento, width: 1.6),
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 44,
          height: 1.05,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          color: acento,
        ),
        headlineLarge: TextStyle(
          fontSize: 30,
          height: 1.15,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.6,
          color: tinta,
        ),
        headlineMedium: TextStyle(
          fontSize: 25,
          height: 1.18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: tinta,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          color: tinta,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: tinta,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: tinta),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: tinta),
        bodySmall: TextStyle(
          fontSize: 12.5,
          height: 1.4,
          color: textoSecundario,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
