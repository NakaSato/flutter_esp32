import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/constants.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/auth/pin_login_screen.dart';
import 'presentation/screens/dashboard/smart_home_dashboard.dart';
import 'presentation/screens/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system overlay style for status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Let the system decide
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding', // Start with onboarding
      // Add page transitions for all routes
      onGenerateRoute: (settings) {
        Widget page;

        // Define route mappings
        switch (settings.name) {
          case '/onboarding':
            page = const OnboardingScreen();
            break;
          case '/login':
            page = const PinLoginScreen();
            break;
          case '/dashboard':
            page = const SmartHomeDashboard(title: AppConstants.appName);
            break;
          case '/settings':
            page = const SettingsScreen(title: 'Settings');
            break;
          default:
            // Redirect unknown routes to onboarding
            page = const OnboardingScreen();
        }

        // Use custom page transition
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: AppTheme.mediumAnimationDuration,
        );
      },
    );
  }
}
