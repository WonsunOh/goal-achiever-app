import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/goal.dart';
import '../../data/models/enums.dart';
import '../viewmodels/goal_viewmodel.dart';

class EditGoalDialog extends ConsumerStatefulWidget {
  final Goal goal;

  const EditGoalDialog({super.key, required this.goal});

  @override
  ConsumerState<EditGoalDialog> createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends ConsumerState<EditGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _motivationQuoteController;

  late GoalCategory _selectedCategory;
  late DateTime _startDate;
  late DateTime _targetDate;
  late List<int> _selectedRecurringDays;
  TimeOfDay? _reminderTime;

  // 요일 매핑 (표시순서: 일, 월, 화, 수, 목, 금, 토)
  static const List<Map<String, dynamic>> _weekdays = [
    {'label': '일', 'value': 7},
    {'label': '월', 'value': 1},
    {'label': '화', 'value': 2},
    {'label': '수', 'value': 3},
    {'label': '목', 'value': 4},
    {'label': '금', 'value': 5},
    {'label': '토', 'value': 6},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    _descriptionController =
        TextEditingController(text: widget.goal.description);
    _motivationQuoteController =
        TextEditingController(text: widget.goal.motivationQuote);
    _selectedCategory = widget.goal.category;
    _startDate = widget.goal.startDate;
    _targetDate = widget.goal.targetDate;
    _selectedRecurringDays = List<int>.from(widget.goal.recurringDays);
    // 기존 알림 시간이 있으면 TimeOfDay로 변환
    if (widget.goal.reminderTime != null) {
      _reminderTime = TimeOfDay(
        hour: widget.goal.reminderTime!.hour,
        minute: widget.goal.reminderTime!.minute,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _motivationQuoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '목표 수정',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '목표 제목',
                    hintText: '예: 10kg 감량하기',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '목표 제목을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: '설명',
                    hintText: '목표에 대한 자세한 설명을 입력하세요',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<GoalCategory>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                  ),
                  items: GoalCategory.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Text(category.icon),
                                const SizedBox(width: 8),
                                Text(category.displayName),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        context,
                        '시작일',
                        _startDate,
                        (date) => setState(() => _startDate = date),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateField(
                        context,
                        '목표일',
                        _targetDate,
                        (date) => setState(() => _targetDate = date),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _motivationQuoteController,
                  decoration: const InputDecoration(
                    labelText: '동기부여 문구 (선택)',
                    hintText: '나를 격려할 문구를 입력하세요',
                  ),
                ),
                const SizedBox(height: 16),
                _buildRecurringDaysSelector(),
                const SizedBox(height: 16),
                _buildReminderSelector(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _updateGoal,
                      child: const Text('저장'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecurringDaysSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '실행 주기',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedRecurringDays.length == 7) {
                    _selectedRecurringDays.clear();
                  } else {
                    _selectedRecurringDays = [1, 2, 3, 4, 5, 6, 7];
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedRecurringDays.length == 7
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '매일',
                  style: TextStyle(
                    color: _selectedRecurringDays.length == 7
                        ? Colors.white
                        : Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _weekdays.map((day) {
            final isSelected = _selectedRecurringDays.contains(day['value']);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedRecurringDays.remove(day['value']);
                    } else {
                      _selectedRecurringDays.add(day['value']);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      day['label'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedRecurringDays.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '새로 추가된 요일에 대해 오늘부터 할일이 생성됩니다',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildReminderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '알림 시간',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: _reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                  child: child!,
                );
              },
            );
            if (selectedTime != null) {
              setState(() {
                _reminderTime = selectedTime;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: _reminderTime != null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _reminderTime != null
                        ? _reminderTime!.format(context)
                        : '알림 시간을 설정하세요',
                    style: TextStyle(
                      color: _reminderTime != null
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.grey,
                    ),
                  ),
                ),
                if (_reminderTime != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _reminderTime = null;
                      });
                    },
                    child: const Icon(Icons.close, size: 20, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
        if (_reminderTime != null && _selectedRecurringDays.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '새로 추가된 요일의 할일에 알림이 자동 설정됩니다',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime date,
    Function(DateTime) onDateChanged,
  ) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 3650)),
        );
        if (selectedDate != null) {
          onDateChanged(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('yy.MM.dd').format(date),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.calendar_today, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _updateGoal() async {
    if (_formKey.currentState!.validate()) {
      try {
        // TimeOfDay를 DateTime으로 변환 (시:분만 사용)
        DateTime? reminderDateTime;
        if (_reminderTime != null) {
          final now = DateTime.now();
          reminderDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            _reminderTime!.hour,
            _reminderTime!.minute,
          );
        }

        final updatedGoal = widget.goal.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory,
          startDate: _startDate,
          targetDate: _targetDate,
          motivationQuote: _motivationQuoteController.text,
          recurringDays: _selectedRecurringDays,
          reminderTime: reminderDateTime,
        );

        await ref.read(goalViewModelProvider.notifier).updateGoal(
          updatedGoal,
          oldGoal: widget.goal,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('목표가 수정되었습니다!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }
}
