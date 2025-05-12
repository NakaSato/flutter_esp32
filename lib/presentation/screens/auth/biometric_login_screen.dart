import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/neumorphic_widgets.dart';
import '../dashboard/smart_home_dashboard.dart';

class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isAuthenticating = false;
  bool _showPin = false;
  final TextEditingController _pinController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);

    // Automatically start authentication after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      _authenticate();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
    });

    // Simulate biometric authentication
    await Future.delayed(Duration(seconds: 2));

    // For demo purposes, we'll simulate success
    _onAuthenticationSuccess();
  }

  void _onAuthenticationSuccess() {
    HapticFeedback.mediumImpact();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                const SmartHomeDashboard(title: 'Smart Home'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _togglePinEntry() {
    setState(() {
      _showPin = !_showPin;
    });
  }

  void _verifyPin() {
    // For demo purposes, we'll use '1234' as the PIN
    if (_pinController.text == '1234') {
      _onAuthenticationSuccess();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Incorrect PIN. Try again.')));
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDarkMode
                    ? [AppTheme.darkBackground, Color(0xFF1A1A1A)]
                    : [AppTheme.lightBackground, Color(0xFFEAEAEA)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and App name
                  Icon(
                    Icons.home_outlined,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Smart Home',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Control your home with a touch',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                    ),
                  ),

                  const SizedBox(height: 60),

                  if (_showPin) ...[
                    // PIN entry
                    NeumorphicContainer(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _pinController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter PIN',
                          hintStyle: TextStyle(
                            color:
                                isDarkMode
                                    ? AppTheme.darkTextSecondary.withOpacity(
                                      0.5,
                                    )
                                    : AppTheme.lightTextSecondary.withOpacity(
                                      0.5,
                                    ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 6,
                          color:
                              isDarkMode
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.lightTextPrimary,
                        ),
                        maxLength: 4,
                        buildCounter:
                            (
                              context, {
                              required currentLength,
                              required isFocused,
                              maxLength,
                            }) => null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Verify PIN'),
                    ),
                    TextButton(
                      onPressed: _togglePinEntry,
                      child: Text('Use Biometric'),
                    ),
                  ] else ...[
                    // Biometric authentication
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              _isAuthenticating ? _pulseAnimation.value : 1.0,
                          child: GestureDetector(
                            onTap: _isAuthenticating ? null : _authenticate,
                            child: NeumorphicContainer(
                              height: 120,
                              width: 120,
                              borderRadius: BorderRadius.circular(60),
                              isActive: _isAuthenticating,
                              child: Icon(
                                _isAuthenticating
                                    ? Icons.fingerprint
                                    : Icons.touch_app,
                                size: 60,
                                color:
                                    _isAuthenticating
                                        ? theme.colorScheme.primary
                                        : isDarkMode
                                        ? AppTheme.darkTextSecondary
                                        : AppTheme.lightTextSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isAuthenticating
                          ? 'Authenticating...'
                          : 'Touch to authenticate',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!_isAuthenticating)
                      TextButton(
                        onPressed: _togglePinEntry,
                        child: Text('Use PIN instead'),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
