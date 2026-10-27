import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/theme_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';
import 'app_shell.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isLogin = true;
  bool obscurePassword = true;

  final TextEditingController _emailController = TextEditingController(
    text: 'alex@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'password123',
  );
  final TextEditingController _nameController = TextEditingController(
    text: 'Alex Johnson',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : 'Alex Johnson';
    final email = _emailController.text.trim().isNotEmpty
        ? _emailController.text.trim()
        : 'alex@example.com';

    ref.read(userProfileProvider.notifier).updateProfile(
      name: name,
      email: email,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AppShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          ThemeModeToggleButton(size: 20),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ResponsiveCenter(
              maxWidth: 460,
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App Title & Tagline
                  Text(
                    'CTrack',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.txtPrimary(isDark),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mindful calorie & nutrition tracking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.txtSecondary(isDark),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Toggleable UI: Login / Sign Up
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.cardVariant(isDark),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!isLogin) setState(() => isLogin = true);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isLogin ? AppColors.card(isDark) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: isLogin
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isLogin ? FontWeight.w700 : FontWeight.w500,
                                  color: isLogin ? AppColors.txtPrimary(isDark) : AppColors.txtSecondary(isDark),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (isLogin) setState(() => isLogin = false);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !isLogin ? AppColors.card(isDark) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: !isLogin
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: !isLogin ? FontWeight.w700 : FontWeight.w500,
                                  color: !isLogin ? AppColors.txtPrimary(isDark) : AppColors.txtSecondary(isDark),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Form Fields
                  if (!isLogin) ...[
                    Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.txtPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.txtMuted(isDark)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.txtPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'name@example.com',
                      prefixIcon: Icon(Icons.mail_outline_rounded, color: AppColors.txtMuted(isDark)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.txtPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.txtMuted(isDark)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.txtMuted(isDark),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Primary Button
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text(
                      isLogin ? 'Log In to CTrack' : 'Create Account',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bypass note / guest link
                  TextButton(
                    onPressed: _handleSubmit,
                    child: Text(
                      'Bypass Authentication (Demo Mode)',
                      style: TextStyle(
                        color: AppColors.txtSecondary(isDark),
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
