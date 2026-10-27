# CTrack

**Nutrition & Macro Tracker** — an intuitive, scientifically calibrated tracker designed to take the guesswork out of daily nutrition.

CTrack helps you track calories, scale portions in grams, balance protein, carbs, and fats, and work toward a personalized daily calorie goal.

## What you can do

- See today's overview at a glance: calories remaining, plus protein, carbs, and fats against their targets
- Log meals under **Breakfast**, **Lunch**, **Dinner**, or **Snack**
- Search for food, then add it to a meal
- Scale portions in grams on the portion screen
- Quick-add calories when you don't need a full food entry
- Edit or delete a logged meal, with undo after deleting
- Move between days, pick a date, or jump back to today
- Adjust your daily calorie goal
- Switch between light and dark themes
- Read the in-app instructions on how to use CTrack

## Screens

| Screen | What it is for |
| --- | --- |
| Landing screen | Intro, feature highlights, how it works, and Launch Tracker |
| Auth screen | Log in |
| App shell | Main app navigation, drawer, and sidebar |
| Dashboard screen | "CTrack Today": progress ring, macros, and today's meals |
| Search screen | Find food and add it to a meal |
| Portion screen | Adjust a portion in grams |
| Instructions screen | How to use CTrack |
| Account screen | Account details |
| Settings screen | App settings and theme |

## How tracking works

- Each day has its own log, made up of food entries for each meal type.
- The dashboard totals calories and macros for the selected day and compares them with the daily goal and macro targets.
- Food entries are stored as a daily log with the food name, meal type, calories, and protein, carbs, and fats.

## Tech stack

- **Flutter** and **Dart** (SDK `^3.13.0`)
- **Flutter Riverpod** (`^3.4.3`) for state management
- **Cupertino Icons** for iOS-style icons
- Light and dark themes, with a theme-mode toggle
- Responsive layout for mobile and wider screens
- Platforms in this repo: Android, iOS, Web, Windows, Linux, and macOS

## Project structure

```
lib/
  main.dart                    # CTrackApp, ProviderScope, light/dark themes
  core/
    constants/app_colors.dart
    theme/app_theme.dart
    utils/app_notification.dart
  models/
    daily_log.dart
    food_item.dart
    user_profile.dart
  providers/
    calorie_tracker_provider.dart
    food_providers.dart
    theme_provider.dart
    user_profile_provider.dart
  repositories/
    mock_food_repository.dart
  screens/
    account_screen.dart
    app_shell.dart
    auth_screen.dart
    dashboard_screen.dart
    instructions_screen.dart
    landing_screen.dart
    portion_screen.dart
    search_screen.dart
    settings_screen.dart
  widgets/
    app_drawer.dart
    app_sidebar.dart
    calorie_progress_ring.dart
    edit_meal_dialog.dart
    macro_nutrient_card.dart
    meal_log_item.dart
    quick_add_dialog.dart
    responsive_layout.dart
    theme_mode_toggle_button.dart
```

## Getting started

You need Flutter installed first. Then, from the project root:

```bash
flutter pub get
flutter run
```

Run on a specific target, for example:

```bash
flutter run -d chrome
flutter run -d windows
```

## Build

Android APK:

```bash
flutter build apk --release
```

Windows:

```bash
flutter build windows --release
```

For Windows, copy the whole `Release` folder when sharing the app, not just the `.exe` on its own.

## Current status

CTrack is in active development. Food data currently comes from a mock food repository, so it is a working prototype for tracking and UI rather than a finished app connected to a live food database.

The calorie and macro figures are estimates to help with everyday tracking. They are not medical advice.
