import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../auth/pin_login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Welcome to Smart Home',
      'description':
          'Control your entire home with a simple, beautiful interface. Manage all your connected devices in one place.',
      'image': Icons.home_outlined,
      'color': AppTheme.primaryColor,
    },
    {
      'title': 'Real-time Monitoring',
      'description':
          'Monitor temperature, humidity, and energy usage in real-time. Get insights about your home environment.',
      'image': Icons.insights_outlined,
      'color': AppTheme.secondaryColor,
    },
    {
      'title': 'Smart Automation',
      'description':
          'Create custom routines and automations. Let your home react to your lifestyle automatically.',
      'image': Icons.auto_awesome_outlined,
      'color': AppTheme.accentColor,
    },
    {
      'title': 'Secure Access',
      'description':
          'Biometric authentication keeps your home secure. Control who has access to your smart home system.',
      'image': Icons.security_outlined,
      'color': AppTheme.primaryVariant,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: AppTheme.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const PinLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return FadeTransition(opacity: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> data, int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing_lg),
      // Use SingleChildScrollView to prevent overflow
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Use minimum space needed
          children: [
          // Image container with animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: data['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Icon(data['image'], size: 80, color: data['color']),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppTheme.spacing_xl),

          // Title
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Text(
                    data['title'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppTheme.spacing_md),

          // Description
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Text(
                    data['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [AppTheme.darkBackground, Color(0xFF1A1A1A)]
                    : [AppTheme.lightBackground, Color(0xFFEAEAEA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing_md),
                  child: TextButton(
                    onPressed: _navigateToLogin,
                    child: Text('Skip'),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder:
                      (context, index) =>
                          _buildPage(_onboardingData[index], index),
                ),
              ),

              // Navigation controls
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing_lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicators
                    Row(
                      children: List.generate(
                        _onboardingData.length,
                        (index) => Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentPage == index
                                    ? Theme.of(context).colorScheme.primary
                                    : (isDarkMode
                                            ? AppTheme.darkTextSecondary
                                            : AppTheme.lightTextSecondary)
                                        .withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),

                    // Next/Get Started button
                    ElevatedButton(
                      onPressed: _navigateToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
