import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CalorieProgressRing extends StatelessWidget {
  final double consumed;
  final double goal;
  final double size;

  const CalorieProgressRing({
    super.key,
    required this.consumed,
    required this.goal,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverGoal = consumed > goal && goal > 0;
    final remaining = isOverGoal ? (consumed - goal) : (goal - consumed);
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    final percentage = goal > 0 ? ((consumed / goal) * 100).toInt() : 0;

    final progressColor = isOverGoal
        ? (consumed > goal * 1.15 ? AppColors.error : AppColors.carbs)
        : AppColors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft glow / base circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.card(isDark),
              boxShadow: [
                BoxShadow(
                  color: progressColor.withValues(alpha: isDark ? 0.18 : 0.10),
                  blurRadius: 24,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),

          // Custom circular painter with rounded cap
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: progress,
              strokeWidth: 14.0,
              trackColor: AppColors.cardVariant(isDark),
              progressColor: progressColor,
            ),
          ),

          // Central information typography
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isOverGoal ? '+${remaining.toStringAsFixed(0)}' : remaining.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: isOverGoal ? progressColor : AppColors.txtPrimary(isDark),
                  letterSpacing: -1.0,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isOverGoal ? 'Calories Over Goal' : 'Calories Remaining',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isOverGoal ? progressColor : AppColors.txtSecondary(isDark),
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverGoal
                      ? progressColor.withValues(alpha: 0.15)
                      : AppColors.primaryGlow(isDark),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${consumed.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} kcal ($percentage%)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isOverGoal
                        ? progressColor
                        : (isDark ? AppColors.protein : AppColors.primaryDark),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      // Progress Arc Paint
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Start from top (-pi / 2)
      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
