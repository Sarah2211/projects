# HabitFlow 🔄

A clean, full-featured **habit tracker** built with Flutter — designed as a portfolio project showcasing Material 3 UI, local persistence, and real app architecture.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android%20%7C%20iOS-lightgrey)


---

## Features

- **Daily overview card** — gradient progress ring showing how many habits you've completed, updates per selected day
- **Interactive week strip** — tap any day of the week to view and log habits for that date
- **Habit tracking** — create habits with a name, category, colour, and weekly target; mark them done with one tap
- **Streak system** — tracks current streak and all-time best streak per habit, calculated from completion history
- **Weekly progress bar** — visual fill on each habit tile showing how close you are to your weekly target
- **Filter bar** — switch between All / Pending / Done with live counts per filter
- **Time-based greeting** — header changes between Good morning / afternoon / evening automatically
- **Persistent storage** — habits survive page refreshes and app restarts via `shared_preferences`
- **Fully responsive** — works on web, Android, and iOS from the same codebase

---

## Screenshots

Overview 

<img width="1920" height="935" alt="image" src="https://github.com/user-attachments/assets/919d5af2-1d9f-4cdc-a881-8c822709a61f" />
<img width="371" height="822" alt="image" src="https://github.com/user-attachments/assets/0718ff8b-de0b-4072-989e-6d161f7ad0ac" />



---

## Getting Started

**Prerequisites:** Flutter SDK ≥ 3.3.0

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/habitflow.git
cd habitflow

# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on a connected device
flutter run
```

---

## Project Structure

```
lib/
├── main.dart                  # App entry point & theme setup
├── models/
│   └── habit.dart             # Habit data model, streak logic, serialisation
├── screens/
│   └── home_screen.dart       # Main UI — summary card, week strip, habit list
├── services/
│   └── storage_service.dart   # SharedPreferences read/write
├── theme/
│   └── app_theme.dart         # Material 3 colour scheme & component defaults
└── widgets/
    ├── habit_tile.dart         # Individual habit card with progress & streaks
    └── add_habit_sheet.dart    # Bottom sheet form to create a new habit
test/
├── habit_test.dart
```

---

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter (Material 3) |
| Language | Dart 3.3+ |
| State management | `setState` (built-in) |
| Persistence | `shared_preferences` |
| Target platforms | Web, Android, iOS |

---

## Roadmap

- [ ] Notifications / reminders
- [ ] Statistics screen with weekly/monthly charts
- [ ] Habit reordering via drag-and-drop
- [ ] Dark mode support
- [ ] iCloud / Google Drive sync

---
