import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool isActive;
  final GestureTapCallback? onTap;
  final Color? activeColor;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = 80.0,
    this.padding = const EdgeInsets.all(AppTheme.spacing_md),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppTheme.neuCurve),
    ),
    this.isActive = false,
    this.onTap,
    this.activeColor,
  });

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTapDown:
          widget.onTap != null
              ? (_) => setState(() => _isPressed = true)
              : null,
      onTapUp:
          widget.onTap != null
              ? (_) {
                setState(() => _isPressed = false);
                widget.onTap!();
              }
              : null,
      onTapCancel:
          widget.onTap != null
              ? () => setState(() => _isPressed = false)
              : null,
      child: AnimatedContainer(
        duration: AppTheme.shortAnimationDuration,
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration:
            widget.isActive
                ? BoxDecoration(
                  borderRadius: widget.borderRadius,
                  color: activeColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                )
                : AppTheme.getNeumorphicDecoration(
                  isDark: isDarkMode,
                  isPressed: _isPressed,
                  radius: widget.borderRadius.topLeft.x,
                ),
        child: widget.child,
      ),
    );
  }
}

class NeumorphicIconButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool isActive;
  final VoidCallback? onPressed;

  const NeumorphicIconButton({
    super.key,
    required this.icon,
    this.size = 50.0,
    this.color,
    this.isActive = false,
    this.onPressed,
  });

  @override
  State<NeumorphicIconButton> createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor =
        widget.color ??
        (widget.isActive
            ? Theme.of(context).colorScheme.primary
            : isDarkMode
            ? AppTheme.darkTextSecondary
            : AppTheme.lightTextSecondary);

    return GestureDetector(
      onTapDown:
          widget.onPressed != null
              ? (_) => setState(() => _isPressed = true)
              : null,
      onTapUp:
          widget.onPressed != null
              ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed!();
              }
              : null,
      onTapCancel:
          widget.onPressed != null
              ? () => setState(() => _isPressed = false)
              : null,
      child: AnimatedContainer(
        duration: AppTheme.shortAnimationDuration,
        width: widget.size,
        height: widget.size,
        decoration: AppTheme.getNeumorphicDecoration(
          isDark: isDarkMode,
          isPressed: _isPressed,
          radius: widget.size / 2,
        ),
        child: Center(
          child: Icon(widget.icon, color: iconColor, size: widget.size * 0.5),
        ),
      ),
    );
  }
}

class NeumorphicCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool isActive;
  final VoidCallback? onTap;
  final Color? activeColor;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(AppTheme.spacing_md),
    this.isActive = false,
    this.onTap,
    this.activeColor,
  });

  @override
  State<NeumorphicCard> createState() => _NeumorphicCardState();
}

class _NeumorphicCardState extends State<NeumorphicCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTapDown:
          widget.onTap != null
              ? (_) => setState(() => _isPressed = true)
              : null,
      onTapUp:
          widget.onTap != null
              ? (_) {
                setState(() => _isPressed = false);
                widget.onTap!();
              }
              : null,
      onTapCancel:
          widget.onTap != null
              ? () => setState(() => _isPressed = false)
              : null,
      child: AnimatedContainer(
        duration: AppTheme.shortAnimationDuration,
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration:
            widget.isActive
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.neuCurve),
                  color: activeColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                )
                : AppTheme.getNeumorphicDecoration(
                  isDark: isDarkMode,
                  isPressed: _isPressed,
                ),
        child: widget.child,
      ),
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool isActive;
  final Color? activeColor;
  final BorderRadius borderRadius;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width = 120,
    this.height = 50,
    this.isActive = false,
    this.activeColor,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppTheme.neuCurve),
    ),
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTapDown:
          widget.onPressed != null
              ? (_) => setState(() => _isPressed = true)
              : null,
      onTapUp:
          widget.onPressed != null
              ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed!();
              }
              : null,
      onTapCancel:
          widget.onPressed != null
              ? () => setState(() => _isPressed = false)
              : null,
      child: AnimatedContainer(
        duration: AppTheme.shortAnimationDuration,
        width: widget.width,
        height: widget.height,
        decoration:
            widget.isActive || _isPressed
                ? BoxDecoration(
                  borderRadius: widget.borderRadius,
                  color: activeColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                )
                : AppTheme.getNeumorphicDecoration(
                  isDark: isDarkMode,
                  isPressed: _isPressed,
                  radius: widget.borderRadius.topLeft.x,
                ),
        child: Center(child: widget.child),
      ),
    );
  }
}

class NeumorphicSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showLabels;

  const NeumorphicSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 60,
    this.height = 30,
    this.activeColor,
    this.inactiveColor,
    this.showLabels = true,
  });

  @override
  State<NeumorphicSwitch> createState() => _NeumorphicSwitchState();
}

class _NeumorphicSwitchState extends State<NeumorphicSwitch> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeOutQuart,
      ),
    );
    
    // Add hover animation controller
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    // Make sure animations are properly stopped before disposing
    _rippleController.stop();
    _hoverController.stop();
    
    // Dispose controllers
    _rippleController.dispose();
    _hoverController.dispose();
    
    super.dispose();
  }

  void _triggerRippleEffect() {
    if (mounted) {
      _rippleController.reset();
      _rippleController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safety check to prevent accessing context after widget is disposed
    if (!mounted) return Container(); // Return an empty container if not mounted
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor =
        widget.inactiveColor ??
        (isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor);
    
    // Calculate text color based on background for better contrast
    final activeTextColor = _contrastColor(activeColor);
    final inactiveTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return MouseRegion(
      onEnter: (_) {
        if (mounted) {
          _hoverController.forward();
        }
      },
      onExit: (_) {
        if (mounted) {
          _hoverController.reverse();
        }
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) {
          if (mounted) {
            setState(() => _isPressed = true);
            _triggerRippleEffect();
            HapticFeedback.lightImpact(); // Add haptic feedback
          }
        },
        onTapUp: (_) {
          if (mounted) {
            setState(() => _isPressed = false);
          }
        },
        onTapCancel: () {
          if (mounted) {
            setState(() => _isPressed = false);
          }
        },
        onTap: () {
          if (mounted) {
            widget.onChanged(!widget.value);
            HapticFeedback.mediumImpact(); // Add stronger haptic feedback on actual toggle
          }
        },
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            // Safety check to prevent building with deactivated widgets
            if (!mounted) return Container();
            // Calculate hover-affected colors
            final hoverActiveColor = Color.lerp(
              activeColor, 
              activeColor.withOpacity(0.8), 
              _hoverAnimation.value
            )!;
            
            final hoverInactiveColor = Color.lerp(
              inactiveColor, 
              Theme.of(context).colorScheme.surfaceVariant, 
              _hoverAnimation.value
            )!;
            
            // Calculate glow intensity based on hover
            final glowSpread = widget.value ? 
                1.0 + (_hoverAnimation.value * 1.5) : 
                0.0 + (_hoverAnimation.value * 0.8);
                
            final glowBlur = 6.0 + (_hoverAnimation.value * 4.0);
            
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                gradient: widget.value
                    ? LinearGradient(
                        colors: [
                          hoverActiveColor.withOpacity(0.7),
                          hoverActiveColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: widget.value ? null : hoverInactiveColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.value
                        ? activeColor.withOpacity(0.3 + (_hoverAnimation.value * 0.2))
                        : Colors.black.withOpacity(0.1 + (_hoverAnimation.value * 0.1)),
                    blurRadius: glowBlur,
                    spreadRadius: glowSpread,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Stack(
            children: [
              // Ripple effect
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Opacity(
                      opacity: 1.0 - _rippleAnimation.value,
                      child: Transform.scale(
                        scale: 0.8 + (_rippleAnimation.value * 0.3),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.height / 2),
                            color: widget.value
                                ? activeColor.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              // ON label
              if (widget.showLabels)
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: widget.value ? 1.0 : 0.0,
                    duration: AppTheme.shortAnimationDuration,
                    child: Center(
                      child: Text(
                        'ON',
                        style: TextStyle(
                          color: activeTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              
              // OFF label
              if (widget.showLabels)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: widget.value ? 0.0 : 1.0,
                    duration: AppTheme.shortAnimationDuration,
                    child: Center(
                      child: Text(
                        'OFF',
                        style: TextStyle(
                          color: inactiveTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              
              // Thumb/knob
              AnimatedPositioned(
                duration: AppTheme.mediumAnimationDuration,
                curve: Curves.easeOutBack, // Improved animation curve
                left: widget.value ? widget.width - widget.height + 2 : 2,
                top: 2,
                child: AnimatedBuilder(
                  animation: _hoverAnimation,
                  builder: (context, child) {
                    // Safety check to prevent building with deactivated widgets
                    if (!mounted) return Container();
                    // Calculate hover scale with animation
                    final hoverScale = _isPressed ? 0.9 : (1.0 + (_hoverAnimation.value * 0.08));
                    
                    // Calculate hover glow color
                    final hoverGlowColor = widget.value
                        ? activeColor.withOpacity(_hoverAnimation.value * 0.4)
                        : Colors.blue.withOpacity(_hoverAnimation.value * 0.2);
                    
                    return Transform.scale(
                      scale: hoverScale,
                      child: Container(
                        width: widget.height - 4,
                        height: widget.height - 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white,
                              widget.value ? 
                                  Color.lerp(Colors.white.withOpacity(0.9), activeColor.withOpacity(0.1), _hoverAnimation.value)! : 
                                  Colors.white.withOpacity(0.8),
                            ],
                            center: Alignment(0.2, 0.2),
                            focal: Alignment(0.2, 0.2),
                            focalRadius: 0.1,
                          ),
                          boxShadow: [
                            // Main shadow
                            BoxShadow(
                              color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.15),
                              blurRadius: _isPressed ? 2 : 4 + (_hoverAnimation.value * 2),
                              spreadRadius: _isPressed ? 0.2 : 0.5 + (_hoverAnimation.value * 0.5),
                              offset: _isPressed ? Offset(0, 1) : Offset(0, 2),
                            ),
                            // Subtle inner shadow
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 1,
                              spreadRadius: 0,
                              offset: Offset(0, 1),
                            ),
                            // Hover glow effect
                            if (_hoverAnimation.value > 0) BoxShadow(
                              color: hoverGlowColor,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: widget.value
                            ? Center(
                                child: Icon(
                                  Icons.check,
                                  size: 12 + (_hoverAnimation.value * 2),
                                  color: Color.lerp(activeColor, activeColor.withOpacity(0.8), _hoverAnimation.value),
                                ),
                              )
                            : _hoverAnimation.value > 0.3 ? Center(
                                child: Icon(
                                  Icons.close,
                                  size: (_hoverAnimation.value - 0.3) * 10,
                                  color: Colors.black26,
                                ),
                              ) : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to determine contrasting text color
  Color _contrastColor(Color backgroundColor) {
    // Calculate luminance (brightness) of the background color
    // If it's dark, use white text; if it's light, use dark text
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

class NeumorphicSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const NeumorphicSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final activeColor = this.activeColor ?? theme.colorScheme.primary;
    final inactiveColor =
        this.inactiveColor ??
        (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300);

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 8,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
        thumbColor: activeColor,
        activeTrackColor: activeColor.withOpacity(0.7),
        inactiveTrackColor: inactiveColor,
        overlayColor: activeColor.withOpacity(0.3),
      ),
      child: Slider(value: value, min: min, max: max, onChanged: onChanged),
    );
  }
}
