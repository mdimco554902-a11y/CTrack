import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Centralized notification service that resolves SnackBar freezing/stuck bugs in Flutter Web
/// and provides consistent floating toasts with guaranteed auto-dismissal.
class AppNotification {
  AppNotification._();

  /// Shows an Undo notification that is guaranteed to auto-dismiss,
  /// has an explicit close ('X') icon, and immediately dismisses upon clicking UNDO.
  static void showUndo(
    BuildContext context, {
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    // 1. Clear any stuck or queued snackbars first
    messenger.clearSnackBars();

    Timer? fallbackTimer;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: const Color(0xFF1E293B), // Slate 800
      duration: duration,
      showCloseIcon: true,
      closeIconColor: Colors.white70,
      dismissDirection: DismissDirection.horizontal,
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_sweep_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: AppColors.primary,
        onPressed: () {
          fallbackTimer?.cancel();
          onUndo();
          // Explicitly dismiss immediately when UNDO is clicked
          try {
            messenger.hideCurrentSnackBar();
          } catch (_) {}
        },
      ),
      onVisible: () {
        // Fallback timer: forces dismissal even if web pointer hover or tab inactive paused it
        fallbackTimer?.cancel();
        fallbackTimer = Timer(duration + const Duration(milliseconds: 300), () {
          try {
            messenger.hideCurrentSnackBar();
          } catch (_) {}
        });
      },
    );

    messenger.showSnackBar(snackBar);
  }

  /// Shows an informative success or action notification.
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: const Color(0xFF0F172A),
        duration: duration,
        showCloseIcon: true,
        closeIconColor: Colors.white70,
        dismissDirection: DismissDirection.horizontal,
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows an error or alert notification.
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.error,
        duration: duration,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        dismissDirection: DismissDirection.horizontal,
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
