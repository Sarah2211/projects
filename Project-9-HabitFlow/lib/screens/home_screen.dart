import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/storage_service.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/habit_tile.dart';

enum HabitFilter { all, pending, done }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();

  List<Habit> _habits = [];
  HabitFilter _filter = HabitFilter.all;
  bool _isLoading = true;
  late DateTime _selectedDay;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _selectedDay = _today;
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await _storageService.loadHabits();
    if (!mounted) return;
    setState(() {
      _habits = habits;
      _isLoading = false;
    });
  }

  Future<void> _saveHabits() async {
    await _storageService.saveHabits(_habits);
  }

  void _addHabit(Habit habit) {
    setState(() => _habits = [habit, ..._habits]);
    _saveHabits();
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      _habits = _habits
          .map((h) => h.id == habit.id ? h.toggleForDay(_selectedDay) : h)
          .toList();
    });
    _saveHabits();
  }

  Future<void> _deleteHabit(Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('Remove "${habit.name}" from your tracker?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _habits = _habits.where((h) => h.id != habit.id).toList());
    _saveHabits();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Habit> get _filteredHabits {
    switch (_filter) {
      case HabitFilter.pending:
        return _habits.where((h) => !h.isCompletedOn(_selectedDay)).toList();
      case HabitFilter.done:
        return _habits.where((h) => h.isCompletedOn(_selectedDay)).toList();
      case HabitFilter.all:
        return _habits;
    }
  }

  int get _completedOnSelected =>
      _habits.where((h) => h.isCompletedOn(_selectedDay)).length;

  double get _dailyProgress =>
      _habits.isEmpty ? 0 : _completedOnSelected / _habits.length;

  int get _bestHabitStreak {
    if (_habits.isEmpty) return 0;
    return _habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);
  }

  int get _totalStreakDays =>
      _habits.fold(0, (sum, h) => sum + h.currentStreak);

  void _showAddHabitSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F8FC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: AddHabitSheet(onCreate: _addHabit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekStart = _today.subtract(Duration(days: _today.weekday - 1));

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadHabits,
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'HabitFlow',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  _greeting(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.black45),
                                ),
                              ],
                            ),
                            _DateBadge(date: _selectedDay),
                          ],
                        ),
                      ),
                    ),

                    // Summary card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _SummaryCard(
                          progress: _dailyProgress,
                          completedToday: _completedOnSelected,
                          totalHabits: _habits.length,
                          bestStreak: _bestHabitStreak,
                          totalStreakDays: _totalStreakDays,
                          selectedDay: _selectedDay,
                          isToday: _isSameDay(_selectedDay, _today),
                        ),
                      ),
                    ),

                    // Week strip — clickable
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _WeekStrip(
                          weekdays: weekdays,
                          weekStart: weekStart,
                          selectedDay: _selectedDay,
                          today: _today,
                          habits: _habits,
                          onDaySelected: (day) =>
                              setState(() => _selectedDay = day),
                        ),
                      ),
                    ),

                    // Filter bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: _FilterBar(
                          filter: _filter,
                          onChanged: (v) => setState(() => _filter = v),
                          allCount: _habits.length,
                          pendingCount: _habits
                              .where((h) => !h.isCompletedOn(_selectedDay))
                              .length,
                          doneCount: _habits
                              .where((h) => h.isCompletedOn(_selectedDay))
                              .length,
                        ),
                      ),
                    ),

                    // Habit list
                    if (_filteredHabits.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          child: _EmptyState(onAddPressed: _showAddHabitSheet),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HabitTile(
                                habit: _filteredHabits[index],
                                isDoneToday: _filteredHabits[index]
                                    .isCompletedOn(_selectedDay),
                                onToggle: () =>
                                    _toggleHabit(_filteredHabits[index]),
                                onDelete: () =>
                                    _deleteHabit(_filteredHabits[index]),
                              ),
                            ),
                            childCount: _filteredHabits.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddHabitSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add habit'),
        elevation: 2,
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 👋';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 👋';
  }
}

// ── Date badge ────────────────────────────────────────────────────────────────
class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date});
  final DateTime date;

  static const _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _weekdays[date.weekday - 1],
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: scheme.primary,
            ),
          ),
          Text(
            '${date.day} ${_months[date.month - 1]} ${date.year}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.progress,
    required this.completedToday,
    required this.totalHabits,
    required this.bestStreak,
    required this.totalStreakDays,
    required this.selectedDay,
    required this.isToday,
  });

  final double progress;
  final int completedToday;
  final int totalHabits;
  final int bestStreak;
  final int totalStreakDays;
  final DateTime selectedDay;
  final bool isToday;

  static const _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ringLabel = isToday
        ? 'today'
        : '${selectedDay.day} ${_shortMonths[selectedDay.month - 1]}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withOpacity(0.72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Ring — fixed centering with explicit sized boxes
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 10,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    color: Colors.white,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      ringLabel,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  totalHabits == 0
                      ? 'No habits yet'
                      : '$completedToday of $totalHabits done',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _StatPill(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Best streak',
                      value: '${bestStreak}d',
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      icon: Icons.track_changes_rounded,
                      label: 'Active',
                      value: '$totalHabits',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Week strip — clickable ────────────────────────────────────────────────────
class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.weekdays,
    required this.weekStart,
    required this.selectedDay,
    required this.today,
    required this.habits,
    required this.onDaySelected,
  });

  final List<String> weekdays;
  final DateTime weekStart;
  final DateTime selectedDay;
  final DateTime today;
  final List<Habit> habits;
  final ValueChanged<DateTime> onDaySelected;

  bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final isToday = _same(day, today);
        final isSelected = _same(day, selectedDay);
        final completedCount =
            habits.where((h) => h.isCompletedOn(day)).length;
        final hasAny = completedCount > 0 && habits.isNotEmpty;
        final allDone =
            habits.isNotEmpty && completedCount == habits.length;

        Color bg;
        if (isSelected) {
          bg = scheme.primary;
        } else if (allDone) {
          bg = scheme.primary.withOpacity(0.12);
        } else {
          bg = Colors.white;
        }

        return Expanded(
          child: GestureDetector(
            onTap: () => onDaySelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isToday
                            ? scheme.primary.withOpacity(0.5)
                            : Colors.black.withOpacity(0.06),
                        width: isToday ? 2 : 1,
                      ),
              ),
              child: Column(
                children: [
                  Text(
                    weekdays[i],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white70 : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white.withOpacity(hasAny ? 1 : 0.3)
                          : hasAny
                              ? scheme.primary
                              : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Filter bar ────────────────────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filter,
    required this.onChanged,
    required this.allCount,
    required this.pendingCount,
    required this.doneCount,
  });
  final HabitFilter filter;
  final ValueChanged<HabitFilter> onChanged;
  final int allCount;
  final int pendingCount;
  final int doneCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = [
      (HabitFilter.all, 'All', allCount),
      (HabitFilter.pending, 'Pending', pendingCount),
      (HabitFilter.done, 'Done', doneCount),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: items.map((item) {
          final (value, label, count) = item;
          final selected = filter == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? scheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white.withOpacity(0.25)
                            : Colors.black.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddPressed});
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.track_changes_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No habits here yet',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first habit to start building consistency and tracking daily progress.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black45),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create first habit'),
          ),
        ],
      ),
    );
  }
}
