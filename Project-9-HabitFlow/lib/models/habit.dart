import 'dart:convert';

class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.colorValue,
    required this.targetDaysPerWeek,
    required this.completedDates,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String category;
  final int colorValue;
  final int targetDaysPerWeek;
  final List<String> completedDates;
  final DateTime createdAt;

  Habit copyWith({
    String? id,
    String? name,
    String? category,
    int? colorValue,
    int? targetDaysPerWeek,
    List<String>? completedDates,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool isCompletedOn(DateTime date) {
    return completedDates.contains(_dayKey(date));
  }

  Habit toggleForDay(DateTime date) {
    final key = _dayKey(date);
    final updated = List<String>.from(completedDates);
    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }
    updated.sort();
    return copyWith(completedDates: updated);
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final set = completedDates.toSet();
    var streak = 0;
    var cursor = DateTime.now();

    while (set.contains(_dayKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  int get bestStreak {
    if (completedDates.isEmpty) return 0;

    final dates = completedDates
        .map((e) => DateTime.parse(e))
        .toList()
      ..sort();

    var best = 1;
    var current = 1;

    for (var i = 1; i < dates.length; i++) {
      final previous = DateTime(dates[i - 1].year, dates[i - 1].month, dates[i - 1].day);
      final currentDate = DateTime(dates[i].year, dates[i].month, dates[i].day);
      if (currentDate.difference(previous).inDays == 1) {
        current++;
        if (current > best) best = current;
      } else if (currentDate.difference(previous).inDays > 1) {
        current = 1;
      }
    }

    return best;
  }

  int get completionsThisWeek {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    var count = 0;

    for (var i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      if (isCompletedOn(day)) count++;
    }

    return count;
  }

  double get weeklyProgress {
    if (targetDaysPerWeek <= 0) return 0;
    return (completionsThisWeek / targetDaysPerWeek).clamp(0, 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'colorValue': colorValue,
      'targetDaysPerWeek': targetDaysPerWeek,
      'completedDates': completedDates,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String? ?? 'General',
      colorValue: map['colorValue'] as int,
      targetDaysPerWeek: map['targetDaysPerWeek'] as int? ?? 4,
      completedDates: List<String>.from(map['completedDates'] as List<dynamic>? ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(jsonDecode(source) as Map<String, dynamic>);

  static String _dayKey(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.toIso8601String();
  }
}
