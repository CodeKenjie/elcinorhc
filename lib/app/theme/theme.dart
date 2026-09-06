import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    secondary: Colors.white70,
    primary: Colors.black,
    tertiary: Colors.grey.shade500
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.black87,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (state) {
        if(state.contains(WidgetState.selected)){
          return const IconThemeData(
            color: Colors.white
          );
        }

        return const IconThemeData(
          color: Colors.black87
        );
      }
    )
  ),
  appBarTheme: AppBarThemeData(
    iconTheme: IconThemeData(color: Colors.black87)
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.black87,
    foregroundColor: Colors.white
  )
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black87,
    primary: Colors.white,
    secondary: Colors.grey.shade900,
    tertiary: Colors.grey.shade700
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.white,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (state) {
        if(state.contains(WidgetState.selected)){
          return const IconThemeData(
            color: Colors.black87
          );
        }

        return const IconThemeData(
          color: Colors.white
        );
      }
    )
  ),
  appBarTheme: AppBarThemeData(
    iconTheme: IconThemeData(color: Colors.white)
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87
  )
);