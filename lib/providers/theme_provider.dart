import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider for managing Light / Dark mode across the application.
/// Defaults to ThemeMode.light as requested by the user.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// Helper getter to quickly check if current theme is dark mode
final isDarkModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark;
});
