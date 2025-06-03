import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/neumorphic_widgets.dart';
import '../dashboard/smart_home_dashboard.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isAuthenticating = false;
  bool _showPin = true; // Changed to true to show PIN by default
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

    // Focus on PIN field automatically after a short delay
    // This ensures the UI is fully loaded before requesting focus
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
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
    // Provide haptic feedback when button is pressed
    HapticFeedback.mediumImpact();

    // For demo purposes, we'll use '1234' as the PIN
    if (_pinController.text == '1234') {
      // Show success feedback before navigation
      setState(() {
        _isAuthenticating = true;
      });

      // Provide success haptic feedback
      HapticFeedback.lightImpact();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN verified successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );

      // Delay navigation slightly to show the success state
      Future.delayed(Duration(milliseconds: 500), () {
        _onAuthenticationSuccess();
      });
    } else {
      // Provide error haptic feedback
      HapticFeedback.heavyImpact();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect PIN. Try again.'),
          backgroundColor: Colors.red,
        ),
      );
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
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
                    'Enter your PIN to continue',
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
                    // PIN instruction
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _isAuthenticating
                            ? "Verifying..."
                            : "Enter your 4-digit PIN",
                        style: TextStyle(
                          color:
                              isDarkMode
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // PIN input field with indicator dots
                    Column(
                      children: [
                        NeumorphicContainer(
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _pinController,
                            enabled: !_isAuthenticating,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter PIN (Default: 1234)',
                              hintStyle: TextStyle(
                                color:
                                    isDarkMode
                                        ? AppTheme.darkTextSecondary
                                            .withOpacity(0.5)
                                        : AppTheme.lightTextSecondary
                                            .withOpacity(0.5),
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
                            autofocus: true,
                            onChanged: (value) {
                              // Provide haptic feedback when a digit is entered
                              if (value.isNotEmpty &&
                                  (value.length >
                                      (_pinController.text.length - 1))) {
                                HapticFeedback.selectionClick();
                              }
                              setState(
                                () {},
                              ); // Rebuild to update PIN indicator
                            },
                            onSubmitted: (_) => _verifyPin(),
                            buildCounter:
                                (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) => null,
                          ),
                        ),
                        SizedBox(height: 16),
                        // PIN indicator dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            bool isFilled = index < _pinController.text.length;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    isFilled
                                        ? theme.colorScheme.primary
                                        : (isDarkMode
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.5,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Verify PIN button with splash effect
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
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
                          elevation: 4,
                          shadowColor: theme.colorScheme.primary.withOpacity(
                            0.5,
                          ),
                        ),
                        child: Text(
                          'Verify PIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Biometric login option
                    TextButton.icon(
                      onPressed: _togglePinEntry,
                      icon: Icon(
                        Icons.fingerprint,
                        color: theme.colorScheme.primary.withOpacity(0.8),
                      ),
                      label: Text(
                        'Use Biometric Instead',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                      TextButton.icon(
                        onPressed: _togglePinEntry,
                        icon: Icon(
                          Icons.dialpad,
                          color: theme.colorScheme.primary.withOpacity(0.8),
                        ),
                        label: Text(
                          'Use PIN Instead',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
            ),
          ),
        ),
      );,
    );
  }
}
