import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/theme_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mode_toggle_button.dart';
import 'app_shell.dart';
import 'auth_screen.dart';
import 'instructions_screen.dart';

class LandingScreen extends ConsumerWidget {
  final VoidCallback? onLaunchTracker;

  const LandingScreen({
    super.key,
    this.onLaunchTracker,
  });

  void _navigateToTracker(BuildContext context) {
    if (onLaunchTracker != null) {
      onLaunchTracker!();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveCenter(
            maxWidth: 1080,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18.0 : 32.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Navigation Bar
                _LandingNavBar(
                  isDark: isDark,
                  onOpenApp: () => _navigateToTracker(context),
                ),
                const SizedBox(height: 36),

                // Hero Section
                _HeroSection(
                  isDark: isDark,
                  isMobile: isMobile,
                  onLaunchTracker: () => _navigateToTracker(context),
                ),
                const SizedBox(height: 56),

                // Core Feature Highlights Grid
                _FeatureSection(isDark: isDark, isMobile: isMobile),
                const SizedBox(height: 56),

                // How It Works Steps
                _HowItWorksSection(isDark: isDark, isMobile: isMobile),
                const SizedBox(height: 56),

                // Call to Action Banner
                _CtaBanner(
                  isDark: isDark,
                  onOpenApp: () => _navigateToTracker(context),
                ),
                const SizedBox(height: 40),

                // Footer
                _LandingFooter(isDark: isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LandingNavBar extends StatelessWidget {
  final bool isDark;
  final VoidCallback onOpenApp;

  const _LandingNavBar({
    required this.isDark,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Brand Logo & Title
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CTrack',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.txtPrimary(isDark),
                  ),
                ),
                Text(
                  'Nutrition & Macro Tracker',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.txtMuted(isDark),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Actions: Spinning Sun/Moon Toggle & Dashboard / Login Button
        Row(
          children: [
            const ThemeModeToggleButton(size: 20),
            const SizedBox(width: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: const Text('Log In'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                minimumSize: const Size(0, 42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onOpenApp,
              child: const Text('Open App'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;
  final VoidCallback onLaunchTracker;

  const _HeroSection({
    required this.isDark,
    required this.isMobile,
    required this.onLaunchTracker,
  });

  @override
  Widget build(BuildContext context) {
    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryGlow(isDark),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Complete Nutrition & Macro Suite',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.protein : AppColors.primaryDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Main Headline
        Text(
          'Master Your Daily Nutrition With Complete Confidence.',
          style: TextStyle(
            fontSize: isMobile ? 32 : 44,
            fontWeight: FontWeight.w900,
            height: 1.15,
            letterSpacing: -1.0,
            color: AppColors.txtPrimary(isDark),
          ),
        ),
        const SizedBox(height: 16),

        // Description
        Text(
          'CTrack is an intuitive, scientifically calibrated nutrition tracker designed to eliminate guesswork. Effortlessly track calories, scale portions in grams, balance your protein, carbs, and fats, and calculate your personalized TDEE with precision.',
          style: TextStyle(
            fontSize: isMobile ? 15 : 17,
            height: 1.5,
            color: AppColors.txtSecondary(isDark),
          ),
        ),
        const SizedBox(height: 28),

        // Call-to-Action Buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                minimumSize: const Size(180, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              onPressed: onLaunchTracker,
              icon: const Icon(Icons.rocket_launch_rounded, size: 20),
              label: const Text(
                'Launch Tracker',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.txtPrimary(isDark),
                side: BorderSide(color: AppColors.brd(isDark), width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                minimumSize: const Size(160, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const InstructionsScreen()),
                );
              },
              icon: const Icon(Icons.menu_book_rounded, size: 18),
              label: const Text(
                'How to Use',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );

    // Live preview card
    final previewCard = Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.brd(isDark)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Today\'s Live Overview',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.txtPrimary(isDark),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'On Track',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Mini Ring Preview
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardVariant(isDark),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 8),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1,066',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.txtPrimary(isDark),
                    ),
                  ),
                  Text(
                    'kcal remaining',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.txtMuted(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Mini Macro Bars
          Row(
            children: [
              _MiniMacroTile(
                label: 'Protein',
                amount: '93g / 150g',
                color: AppColors.protein,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _MiniMacroTile(
                label: 'Carbs',
                amount: '124g / 230g',
                color: AppColors.carbs,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _MiniMacroTile(
                label: 'Fats',
                amount: '28g / 65g',
                color: AppColors.fat,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          textContent,
          const SizedBox(height: 32),
          previewCard,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: textContent),
        const SizedBox(width: 48),
        Expanded(flex: 5, child: previewCard),
      ],
    );
  }
}

class _MiniMacroTile extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final bool isDark;

  const _MiniMacroTile({
    required this.label,
    required this.amount,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.cardVariant(isDark),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.txtSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;

  const _FeatureSection({required this.isDark, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureData(
        icon: Icons.calculate_rounded,
        iconColor: AppColors.primary,
        title: 'Scientific TDEE & BMR Engine',
        description:
            'Calculates maintenance calories, deficit targets, and lean surplus goals using the medical Mifflin-St Jeor formula.',
      ),
      _FeatureData(
        icon: Icons.scale_rounded,
        iconColor: AppColors.protein,
        title: 'Gram-Precision Portion Scaler',
        description:
            'Adjust portion weights in real-time. Calories and macros instantly recalculate across 30+ everyday foods and custom recipes.',
      ),
      _FeatureData(
        icon: Icons.flash_on_rounded,
        iconColor: AppColors.carbs,
        title: 'Quick Add & Custom Meals',
        description:
            'Log meals in seconds with quick presets, category shortcuts (+), custom foods, and 1-tap editing directly from the dashboard.',
      ),
      _FeatureData(
        icon: Icons.nightlight_round,
        iconColor: AppColors.moonIndigo,
        title: 'Dynamic Light & Dark Modes',
        description:
            'Seamlessly switch between an energizing daytime theme and a low-glare midnight obsidian theme with spinning sun/moon transition.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              const Text(
                'WHY CHOOSE CTRACK',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Everything You Need For Nutrition Mastery',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.txtPrimary(isDark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Grid of 4 Cards
        isMobile
            ? Column(
                children: features
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _FeatureCard(data: f, isDark: isDark),
                        ))
                    .toList(),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _FeatureCard(data: features[0], isDark: isDark),
                        const SizedBox(height: 16),
                        _FeatureCard(data: features[2], isDark: isDark),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _FeatureCard(data: features[1], isDark: isDark),
                        const SizedBox(height: 16),
                        _FeatureCard(data: features[3], isDark: isDark),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class _FeatureData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _FeatureData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  final bool isDark;

  const _FeatureCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brd(isDark)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.txtPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.txtSecondary(isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;

  const _HowItWorksSection({required this.isDark, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _StepCard(
        number: '01',
        title: 'Set Your Targets',
        description: 'Input your height, weight, and fitness goal to generate scientific daily calorie & macro targets.',
        isDark: isDark,
      ),
      _StepCard(
        number: '02',
        title: 'Log Foods in Grams',
        description: 'Search standard ingredients or add custom foods. Gram-level scaling ensures 100% nutritional fidelity.',
        isDark: isDark,
      ),
      _StepCard(
        number: '03',
        title: 'Track Your Balance',
        description: 'Watch your calorie ring fill up and monitor protein, carb, and fat goals in real time throughout your day.',
        isDark: isDark,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              const Text(
                'SIMPLE 3-STEP PROCESS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.carbs,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'How CTrack Works For You',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.txtPrimary(isDark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        isMobile
            ? Column(
                children: steps
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: s,
                        ))
                    .toList(),
              )
            : Row(
                children: [
                  Expanded(child: steps[0]),
                  const SizedBox(width: 14),
                  Expanded(child: steps[1]),
                  const SizedBox(width: 14),
                  Expanded(child: steps[2]),
                ],
              ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool isDark;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brd(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.txtPrimary(isDark),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.txtSecondary(isDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaBanner extends StatelessWidget {
  final bool isDark;
  final VoidCallback onOpenApp;

  const _CtaBanner({
    required this.isDark,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 44,
          ),
          const SizedBox(height: 12),
          const Text(
            'Ready to start your mindful nutrition journey?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jump straight into your daily dashboard with realistic demo data, or personalize your stats in seconds.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              minimumSize: const Size(200, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: onOpenApp,
            child: const Text(
              'Open Today\'s Tracker',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _LandingFooter extends StatelessWidget {
  final bool isDark;

  const _LandingFooter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CTrack v1.0.0 • Mindful Nutrition & Calorie Tracking',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.txtMuted(isDark),
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const InstructionsScreen()),
                );
              },
              child: Text(
                'Instructions',
                style: TextStyle(fontSize: 12, color: AppColors.txtSecondary(isDark)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: Text(
                'Account',
                style: TextStyle(fontSize: 12, color: AppColors.txtSecondary(isDark)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
