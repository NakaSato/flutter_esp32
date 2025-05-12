import 'package:flutter/material.dart';
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

class NeumorphicSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;

  const NeumorphicSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 60,
    this.height = 30,
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
        (isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: AppTheme.mediumAnimationDuration,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? activeColor.withOpacity(0.2) : inactiveColor,
          border: Border.all(
            color:
                value
                    ? activeColor
                    : isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: AppTheme.mediumAnimationDuration,
              curve: Curves.easeInOut,
              left: value ? width - height + 2 : 2,
              top: 2,
              child: Container(
                width: height - 4,
                height: height - 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      value
                          ? activeColor
                          : isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
