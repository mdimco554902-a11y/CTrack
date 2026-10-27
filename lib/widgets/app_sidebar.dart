import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/calorie_tracker_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_profile_provider.dart';
import 'theme_mode_toggle_button.dart';

class AppSidebar extends ConsumerWidget {
  final bool isCollapsed;
  final int selectedIndex;
  final VoidCallback onToggleCollapse;
  final ValueChanged<int> onSelectIndex;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.isCollapsed,
    required this.selectedIndex,
    required this.onToggleCollapse,
    required this.onSelectIndex,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final profile = ref.watch(userProfileProvider);
    final tracker = ref.watch(calorieTrackerProvider);

    final sidebarWidth = isCollapsed ? 74.0 : 252.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOutCubic,
      width: sidebarWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        border: Border(
          right: BorderSide(
            color: AppColors.brd(isDark),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: ClipRect(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: sidebarWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          // Sidebar Header: Logo & Collapse / Expand Button
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 12.0 : 16.0,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.brd(isDark), width: 1.0),
              ),
            ),
            child: SizedBox(
              height: 44,
              child: isCollapsed
                  ? Center(
                      child: Tooltip(
                        message: 'Expand sidebar',
                        child: InkWell(
                          onTap: onToggleCollapse,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.cardVariant(isDark),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.brd(isDark)),
                            ),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 22,
                              color: AppColors.txtSecondary(isDark),
                            ),
                          ),
                        ),
                      ),
                    )
                  : ClipRect(
                      child: OverflowBox(
                        alignment: Alignment.centerLeft,
                        minWidth: 0,
                        maxWidth: 220,
                        child: SizedBox(
                          width: 219,
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primary, AppColors.primaryDark],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CTrack',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                        color: AppColors.txtPrimary(isDark),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Nutrition Suite',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.txtMuted(isDark),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Tooltip(
                                message: 'Collapse sidebar',
                                child: InkWell(
                                  onTap: onToggleCollapse,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardVariant(isDark),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.menu_open_rounded,
                                      size: 20,
                                      color: AppColors.txtSecondary(isDark),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),

          // User Profile Snippet
          if (!isCollapsed)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardVariant(isDark),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.brd(isDark)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name.trim().substring(0, 1).toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.txtPrimary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${tracker.dailyCalorieGoal.toStringAsFixed(0)} kcal goal',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.protein : AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Tooltip(
                message: '${profile.name} (${tracker.dailyCalorieGoal.toStringAsFixed(0)} kcal)',
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name.trim().substring(0, 1).toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              children: [
                _NavItem(
                  index: 0,
                  selectedIndex: selectedIndex,
                  icon: Icons.dashboard_rounded,
                  label: 'Today\'s Tracker',
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  onTap: () => onSelectIndex(0),
                ),
                _NavItem(
                  index: 1,
                  selectedIndex: selectedIndex,
                  icon: Icons.person_rounded,
                  label: 'Account & TDEE',
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  onTap: () => onSelectIndex(1),
                ),
                _NavItem(
                  index: 2,
                  selectedIndex: selectedIndex,
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  onTap: () => onSelectIndex(2),
                ),
                _NavItem(
                  index: 3,
                  selectedIndex: selectedIndex,
                  icon: Icons.menu_book_rounded,
                  label: 'How to Use',
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  onTap: () => onSelectIndex(3),
                ),
              ],
            ),
          ),

          // Bottom Controls: Theme Mode & Logout
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 10.0 : 14.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.brd(isDark), width: 1.0),
              ),
            ),
            child: Column(
              children: [
                // Theme Toggle
                if (!isCollapsed)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cardVariant(isDark),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isDark ? 'Dark Theme' : 'Light Theme',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.txtPrimary(isDark),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const ThemeModeToggleButton(size: 18),
                      ],
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(child: ThemeModeToggleButton(size: 20)),
                  ),

                // Logout Button
                if (!isCollapsed)
                  InkWell(
                    onTap: onLogout,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Tooltip(
                    message: 'Log Out',
                    child: IconButton(
                      icon: const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
                      onPressed: onLogout,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
),
);
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final String label;
  final bool isCollapsed;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.label,
    required this.isCollapsed,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;

    final selectedBg = isDark
        ? AppColors.primary.withValues(alpha: 0.22)
        : AppColors.primaryLight;
    final selectedColor = isDark ? AppColors.protein : AppColors.primary;
    final unselectedColor = AppColors.txtSecondary(isDark);

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
          message: label,
          preferBelow: false,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? selectedBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.2)
                      : null,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? selectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.35), width: 1.2)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
