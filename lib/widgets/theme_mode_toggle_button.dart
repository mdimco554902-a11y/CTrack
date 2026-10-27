import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/theme_provider.dart';

class ThemeModeToggleButton extends ConsumerStatefulWidget {
  final double size;
  final bool showBackground;

  const ThemeModeToggleButton({
    super.key,
    this.size = 22,
    this.showBackground = true,
  });

  @override
  ConsumerState<ThemeModeToggleButton> createState() => _ThemeModeToggleButtonState();
}

class _ThemeModeToggleButtonState extends ConsumerState<ThemeModeToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleToggle() {
    final currentMode = ref.read(themeModeProvider);
    final nextMode = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    // Trigger spinning animation
    _rotationController.forward(from: 0.0);

    // Update global Riverpod theme state
    ref.read(themeModeProvider.notifier).state = nextMode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);

    final iconColor = isDark ? AppColors.moonIndigo : AppColors.sunAmber;
    final bgColor = isDark
        ? AppColors.moonIndigo.withValues(alpha: 0.15)
        : AppColors.sunAmber.withValues(alpha: 0.15);

    return Tooltip(
      message: isDark ? 'Switch to Light Mode (Sun)' : 'Switch to Dark Mode (Moon)',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleToggle,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: widget.showBackground
                ? BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  )
                : null,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                // Spinning transition: rotate full 360 degrees (2 * pi)
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * math.pi,
                  child: child,
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: isDark
                    ? Icon(
                        Icons.nightlight_round,
                        key: const ValueKey('moon_icon'),
                        color: iconColor,
                        size: widget.size,
                      )
                    : Icon(
                        Icons.wb_sunny_rounded,
                        key: const ValueKey('sun_icon'),
                        color: iconColor,
                        size: widget.size,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
