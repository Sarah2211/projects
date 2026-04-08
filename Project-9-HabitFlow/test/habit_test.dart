import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow_portfolio/models/habit.dart';

void main() {
  test('toggleForDay adds and removes a completion', () {
    final habit = Habit(
      id: '1',
      name: 'Read',
      category: 'Learning',
      colorValue: 0xFF000000,
      targetDaysPerWeek: 4,
      completedDates: const [],
      createdAt: DateTime(2026, 1, 1),
    );

    final date = DateTime(2026, 1, 5);
    final updated = habit.toggleForDay(date);
    expect(updated.isCompletedOn(date), true);

    final reverted = updated.toggleForDay(date);
    expect(reverted.isCompletedOn(date), false);
  });
}
