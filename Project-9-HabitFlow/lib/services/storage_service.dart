import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

class StorageService {
  static const _habitsKey = 'habits_v1';

  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_habitsKey) ?? [];
    return items.map(Habit.fromJson).toList();
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = habits.map((habit) => habit.toJson()).toList();
    await prefs.setStringList(_habitsKey, encoded);
  }
}
