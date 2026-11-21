import 'package:flutter/material.dart';

abstract final class TemaApp {
  // Superficies de roca oscura y pizarra
  static const Color fondo = Color(0xff0f1216);
  static const Color superficie = Color(0xff1b2027);
  static const Color superficieAtenuada = Color(0xff252c35);

  // Textos claros y metálicos
  static const Color tinta = Color(0xffe9edf2);
  static const Color textoSecundario = Color(0xff9aa5b4);

  // Bordes tipo piedra/metal tallado
  static const Color borde = Color(0xff3a4350);

  // Acentos inspirados en el brillo rúnico y las chispas cálidas
  static const Color acento = Color(0xff4ea8de);
  static const Color acentoSuave = Color(0xff172d3d);
  static const Color acentoTexto = Color(0xffff9f43);

  static const Color sol = Color(0xfff59e0b);
  static const Color azul = Color(0xff5bc0eb);

  static const Color solSuave = Color(0xff332209);
  static const Color azulSuave = Color(0xff132938);

  // Estados
  static const Color exito = Color(0xff34d399);
  static const Color aviso = Color(0xfff59e0b);
  static const Color error = Color(0xffef4444);

  // Sombra profunda
  static const Color sombra = Color(0x99000000);

  static const double radio = 18;
  static const double radioControl = 14;

  static const String fuente = 'Montserrat';

  static ThemeData crear() {
    final esquema =
        ColorScheme.fromSeed(
          seedColor: acento,
          brightness: Brightness.dark,
        ).copyWith(
          primary: acento,
          onPrimary: const Color(0xff08131a),
          primaryContainer: acentoSuave,
          onPrimaryContainer: azul,
          secondary: sol,
          onSecondary: const Color(0xff1a1204),
          secondaryContainer: solSuave,
          onSecondaryContainer: acentoTexto,
          surface: fondo,
          onSurface: tinta,
          onSurfaceVariant: textoSecundario,
          surfaceContainerHighest: superficie,
          outline: borde,
          outlineVariant: borde,
          error: error,
        );

    const pildora = StadiumBorder();
    const textoBoton = TextStyle(
      fontSize: 15.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );
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
          letterSpacing: 0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: superficie,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shadowColor: sombra,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radio),
          side: const BorderSide(color: borde, width: 1.2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: superficie,
        indicatorColor: acentoSuave,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? azul
                : textoSecundario,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => TextStyle(
            color: estados.contains(WidgetState.selected)
                ? azul
                : textoSecundario,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: const WidgetStatePropertyAll(superficie),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(2),
        shadowColor: const WidgetStatePropertyAll(sombra),
        side: const WidgetStatePropertyAll(BorderSide(color: borde)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radioControl),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sol,
          foregroundColor: const Color(0xff141008),
          disabledBackgroundColor: superficieAtenuada,
          disabledForegroundColor: textoSecundario,
          minimumSize: tamanoBoton,
          shape: pildora,
          textStyle: textoBoton,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: superficie,
          foregroundColor: tinta,
          side: const BorderSide(color: borde, width: 1.2),
          minimumSize: tamanoBoton,
          shape: pildora,
          textStyle: textoBoton,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: azul,
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
        floatingLabelStyle: const TextStyle(color: azul),
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
          borderSide: const BorderSide(color: azul, width: 1.6),
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 44,
          height: 1.05,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.8,
          color: azul,
        ),
        headlineLarge: TextStyle(
          fontSize: 30,
          height: 1.15,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.4,
          color: tinta,
        ),
        headlineMedium: TextStyle(
          fontSize: 25,
          height: 1.18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          color: tinta,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
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
          color: acentoTexto,
        ),
      ),
    );
  }
}
