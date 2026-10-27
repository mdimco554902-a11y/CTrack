import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/responsive_layout.dart';
import 'account_screen.dart';
import 'dashboard_screen.dart';
import 'instructions_screen.dart';
import 'landing_screen.dart';
import 'settings_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  final int initialIndex;

  const AppShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  late int _selectedNavIndex;
  bool _isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.initialIndex;
  }

  void _showLogoutDialog() {
    final isDark = ref.read(isDarkModeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
            SizedBox(width: 8),
            Text(
              'Log Out of CTrack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out? You will be returned to the landing page.',
          style: TextStyle(color: AppColors.txtSecondary(isDark)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.txtSecondary(isDark))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(100, 42),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LandingScreen()),
                (route) => false,
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedNavIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const AccountScreen();
      case 2:
        return const SettingsScreen();
      case 3:
        return const InstructionsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      // Mobile View: Sidebar transfers completely to bottom navigation bar
      return Scaffold(
        backgroundColor: AppColors.bg(isDark),
        body: SafeArea(
          child: _buildCurrentScreen(),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.card(isDark),
            border: Border(
              top: BorderSide(
                color: AppColors.brd(isDark),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MobileNavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Tracker',
                    isSelected: _selectedNavIndex == 0,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedNavIndex = 0),
                  ),
                  _MobileNavItem(
                    icon: Icons.person_rounded,
                    label: 'Account',
                    isSelected: _selectedNavIndex == 1,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedNavIndex = 1),
                  ),
                  _MobileNavItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    isSelected: _selectedNavIndex == 2,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedNavIndex = 2),
                  ),
                  _MobileNavItem(
                    icon: Icons.menu_book_rounded,
                    label: 'How to Use',
                    isSelected: _selectedNavIndex == 3,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedNavIndex = 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Desktop & Tablet View: Fit & Fixed left sidebar with collapse / expand
    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSidebar(
              isCollapsed: _isSidebarCollapsed,
              selectedIndex: _selectedNavIndex,
              onToggleCollapse: () {
                setState(() => _isSidebarCollapsed = !_isSidebarCollapsed);
              },
              onSelectIndex: (index) {
                setState(() => _selectedNavIndex = index);
              },
              onLogout: _showLogoutDialog,
            ),
            Expanded(
              child: _buildCurrentScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? AppColors.protein : AppColors.primary;
    final inactiveColor = AppColors.txtMuted(isDark);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
