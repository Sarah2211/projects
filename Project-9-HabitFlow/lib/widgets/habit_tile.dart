import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.isDoneToday,
    required this.onToggle,
    required this.onDelete,
  });

  final Habit habit;
  final bool isDoneToday;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final accent = Color(habit.colorValue);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: isDoneToday ? accent.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDoneToday ? accent.withOpacity(0.3) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Color dot + icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _categoryIcon(habit.category),
                color: accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          habit.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: isDoneToday
                                ? TextDecoration.lineThrough
                                : null,
                            color: isDoneToday ? Colors.black38 : Colors.black87,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        onSelected: (value) {
                          if (value == 'delete') onDelete();
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${habit.category} · ${habit.completionsThisWeek}/${habit.targetDaysPerWeek} this week',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black45),
                  ),
                  const SizedBox(height: 10),

                  // Weekly progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: habit.weeklyProgress,
                      minHeight: 5,
                      backgroundColor: Colors.black.withOpacity(0.07),
                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Streak chips
                  Row(
                    children: [
                      _StreakChip(
                        icon: Icons.local_fire_department_rounded,
                        label: '${habit.currentStreak}d streak',
                        color: habit.currentStreak > 0
                            ? Colors.deepOrange
                            : Colors.black26,
                      ),
                      const SizedBox(width: 8),
                      _StreakChip(
                        icon: Icons.emoji_events_rounded,
                        label: 'Best ${habit.bestStreak}d',
                        color: Colors.amber.shade700,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Completion toggle
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isDoneToday ? accent : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDoneToday ? accent : Colors.black26,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isDoneToday
                      ? Icons.check_rounded
                      : Icons.circle_outlined,
                  color: isDoneToday ? Colors.white : Colors.black26,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    final c = category.toLowerCase();
    if (c.contains('health') || c.contains('fitness')) {
      return Icons.favorite_rounded;
    }
    if (c.contains('learn') || c.contains('study') || c.contains('read')) {
      return Icons.menu_book_rounded;
    }
    if (c.contains('work') || c.contains('career')) {
      return Icons.work_rounded;
    }
    if (c.contains('mind') || c.contains('meditat')) {
      return Icons.self_improvement_rounded;
    }
    if (c.contains('sport') || c.contains('gym') || c.contains('run')) {
      return Icons.directions_run_rounded;
    }
    return Icons.star_rounded;
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
