import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors - updated for better vibrancy and accessibility
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFB00020);

  // Light theme background shades
  static const Color lightBackground = Color(0xFFF8F8F8);
  static const Color lightSurface = Colors.white;
  static const Color lightCardColor = Colors.white;

  // Dark theme background shades
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2C2C2C);

  // Typography colors
  static const Color lightTextPrimary = Color(0xFF1F1F1F);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Neumorphic design colors
  static const Color neuLightStart = Color(0xFFFFFFFF);
  static const Color neuLightEnd = Color(0xFFD1D9E6);
  static const Color neuDarkStart = Color(0xFF2D2F39);
  static const Color neuDarkEnd = Color(0xFF1F1F1F);

  // Neumorphic shadow colors
  static const Color neuLightShadowDark = Color(0xFFA8B1C0);
  static const Color neuLightShadowLight = Color(0xFFFFFFFF);
  static const Color neuDarkShadowDark = Color(0xFF151515);
  static const Color neuDarkShadowLight = Color(0xFF353535);

  // Elevated style for cards and buttons - refined for modern look
  static final cardElevation = 2.0; // Reduced for more subtle effect
  static final buttonElevation = 1.0; // Reduced for modern flat design trend
  static final borderRadius = 16.0; // Increased for softer appearance

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);

  // Spacing constants
  static const double spacing_xs = 4.0;
  static const double spacing_sm = 8.0;
  static const double spacing_md = 16.0;
  static const double spacing_lg = 24.0;
  static const double spacing_xl = 32.0;

  // Neumorphic constants
  static const double neuDepth = 5.0;
  static const double neuIntensity = 0.5;
  static const double neuCurve = 16.0;

  // Gradient presets for cards
  static LinearGradient getLightNeuGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [neuLightStart, neuLightEnd],
    );
  }

  static LinearGradient getDarkNeuGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [neuDarkStart, neuDarkEnd],
    );
  }

  // Helper method to create neumorphic box decoration
  static BoxDecoration getNeumorphicDecoration({
    required bool isDark,
    bool isPressed = false,
    double radius = neuCurve,
  }) {
    if (isDark) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient:
            isPressed
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [neuDarkEnd, neuDarkStart],
                )
                : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [neuDarkStart, neuDarkEnd],
                ),
        boxShadow:
            isPressed
                ? []
                : [
                  BoxShadow(
                    color: neuDarkShadowDark.withOpacity(neuIntensity),
                    offset: Offset(neuDepth, neuDepth),
                    blurRadius: neuDepth * 2,
                  ),
                  BoxShadow(
                    color: neuDarkShadowLight.withOpacity(neuIntensity),
                    offset: Offset(-neuDepth, -neuDepth),
                    blurRadius: neuDepth * 2,
                  ),
                ],
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient:
            isPressed
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [neuLightEnd, neuLightStart],
                )
                : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [neuLightStart, neuLightEnd],
                ),
        boxShadow:
            isPressed
                ? []
                : [
                  BoxShadow(
                    color: neuLightShadowDark.withOpacity(neuIntensity),
                    offset: Offset(neuDepth, neuDepth),
                    blurRadius: neuDepth * 2,
                  ),
                  BoxShadow(
                    color: neuLightShadowLight.withOpacity(neuIntensity),
                    offset: Offset(-neuDepth, -neuDepth),
                    blurRadius: neuDepth * 2,
                  ),
                ],
      );
    }
  }

  // Light theme configuration
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryVariant.withOpacity(0.8),
      onPrimaryContainer: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      secondaryContainer: secondaryVariant.withOpacity(0.8),
      onSecondaryContainer: Colors.black,
      tertiary: accentColor,
      onTertiary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      surface: lightSurface,
      onSurface: lightTextPrimary,
      surfaceContainerHighest: lightBackground.withOpacity(0.7),
      onSurfaceVariant: lightTextSecondary,
      outline: lightTextSecondary.withOpacity(0.5),
    ),
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightCardColor,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: lightTextPrimary),
      bodyMedium: TextStyle(color: lightTextSecondary),
    ),
    cardTheme: CardTheme(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: buttonElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: lightTextPrimary,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return lightTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return lightTextSecondary.withOpacity(0.3);
      }),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: primaryColor,
      activeTrackColor: primaryColor,
      inactiveTrackColor: lightTextSecondary.withOpacity(0.3),
    ),
  );

  // Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor.withOpacity(0.8),
      onPrimary: Colors.white,
      primaryContainer: primaryVariant.withOpacity(0.8),
      onPrimaryContainer: Colors.white,
      secondary: secondaryColor.withOpacity(0.8),
      onSecondary: Colors.black,
      secondaryContainer: secondaryVariant.withOpacity(0.8),
      onSecondaryContainer: Colors.black,
      tertiary: accentColor,
      onTertiary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      surface: darkSurface,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: darkBackground.withOpacity(0.7),
      onSurfaceVariant: darkTextSecondary,
      outline: darkTextSecondary.withOpacity(0.5),
    ),
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCardColor,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: darkTextPrimary),
      bodyMedium: TextStyle(color: darkTextSecondary),
    ),
    cardTheme: CardTheme(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: buttonElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: darkTextPrimary,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return darkTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return darkTextSecondary.withOpacity(0.3);
      }),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: primaryColor,
      activeTrackColor: primaryColor,
      inactiveTrackColor: darkTextSecondary.withOpacity(0.3),
    ),
  );
}
