import 'package:flutter/material.dart';

import '../models/habit.dart';

class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key, required this.onCreate});

  final ValueChanged<Habit> onCreate;

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Health');
  int _selectedColor = _presetColors.first.value;
  double _targetDays = 4;

  static const _presetColors = [
    Color(0xFF5B7CFA),
    Color(0xFF7A5AF8),
    Color(0xFF12B76A),
    Color(0xFFF79009),
    Color(0xFFEF4444),
    Color(0xFF06B6D4),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final habit = Habit(
      id: now.microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: _categoryController.text.trim().isEmpty ? 'General' : _categoryController.text.trim(),
      colorValue: _selectedColor,
      targetDaysPerWeek: _targetDays.round(),
      completedDates: const [],
      createdAt: now,
    );

    widget.onCreate(habit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Create habit', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Add a habit you want to track every week.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Habit name', hintText: 'Read 10 pages'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter a habit name';
                  if (value.trim().length < 3) return 'Use at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category', hintText: 'Health, Learning, Fitness'),
              ),
              const SizedBox(height: 18),
              Text('Target days per week: ${_targetDays.round()}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              Slider(
                value: _targetDays,
                min: 1,
                max: 7,
                divisions: 6,
                label: _targetDays.round().toString(),
                onChanged: (value) => setState(() => _targetDays = value),
              ),
              const SizedBox(height: 8),
              Text('Color', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _presetColors.map((color) {
                  final selected = _selectedColor == color.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? Colors.black : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: selected ? const Icon(Icons.check, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Add habit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
