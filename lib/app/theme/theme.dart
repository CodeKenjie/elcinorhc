import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color.fromARGB(255, 238, 240, 240),
    secondary: Colors.white,
    primary: Colors.black,
    tertiary: Colors.grey.shade700
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: const Color.fromARGB(255, 76, 175, 142),
    backgroundColor: Colors.white,
    shadowColor: Colors.black,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (state) {
        if(state.contains(WidgetState.selected)){
          return const IconThemeData(
            color: Colors.white
          );
        }

        return const IconThemeData(
          color: Color.fromARGB(255, 3, 8, 7),
        );
      }
    )
  ),
  appBarTheme: AppBarThemeData(
    iconTheme: IconThemeData(color:const Color.fromARGB(255, 3, 8, 7)),
    backgroundColor: Colors.white
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 37, 83, 68) ,
    foregroundColor: Colors.white
  )
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 12, 12, 12),
    primary: Colors.white,
    secondary: const Color.fromARGB(255, 24, 24, 24),
    tertiary: Colors.grey.shade400
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: const Color.fromARGB(255, 76, 175, 142),
    backgroundColor: const Color.fromARGB(255, 24, 24, 24),
    shadowColor: Colors.black,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (state) {
        if(state.contains(WidgetState.selected)){
          return const IconThemeData(
            color: Colors.white
          );
        }

        return const IconThemeData(
          color: Color.fromARGB(255, 37, 83, 68)
        );
      }
    )
  ),
  appBarTheme: AppBarThemeData(
    iconTheme: IconThemeData(color: const Color.fromARGB(255, 76, 175, 142)),
    backgroundColor: const Color.fromARGB(255, 24, 24, 24),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 37, 83, 68) ,
    foregroundColor: Colors.white
  )
);