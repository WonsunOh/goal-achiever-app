import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/enums.dart';
import '../viewmodels/goal_viewmodel.dart';
import '../viewmodels/daily_task_viewmodel.dart';

class CreateTaskDialog extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final String? preSelectedGoalId;

  const CreateTaskDialog({
    super.key,
    required this.selectedDate,
    this.preSelectedGoalId,
  });

  @override
  ConsumerState<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends ConsumerState<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedGoalId;
  Priority _selectedPriority = Priority.medium;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _selectedGoalId = widget.preSelectedGoalId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalViewModelProvider);

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
                  '새 할일 추가',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('yyyy년 MM월 dd일').format(widget.selectedDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                goalsAsync.when(
                  data: (goals) {
                    final activeGoals =
                        goals.where((g) => !g.isCompleted).toList();

                    if (activeGoals.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '먼저 목표를 추가해주세요',
                                style: TextStyle(color: Colors.orange.shade900),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      value: _selectedGoalId,
                      decoration: const InputDecoration(
                        labelText: '연결된 목표',
                      ),
                      items: activeGoals
                          .map((goal) => DropdownMenuItem(
                                value: goal.id,
                                child: Text(goal.title),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGoalId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '목표를 선택해주세요';
                        }
                        return null;
                      },
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stack) => Text('오류: $error'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '할일 제목',
                    hintText: '예: 30분 운동하기',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '할일 제목을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: '설명 (선택)',
                    hintText: '할일에 대한 상세 설명',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Priority>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: '우선순위',
                  ),
                  items: Priority.values
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority.displayName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _reminderTime = time;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '알림 시간 (선택)',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _reminderTime != null
                              ? _reminderTime!.format(context)
                              : '알림 없음',
                        ),
                        const Icon(Icons.access_time, size: 16),
                      ],
                    ),
                  ),
                ),
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
                      onPressed: _createTask,
                      child: const Text('추가'),
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

  Future<void> _createTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        DateTime? reminderDateTime;
        if (_reminderTime != null) {
          reminderDateTime = DateTime(
            widget.selectedDate.year,
            widget.selectedDate.month,
            widget.selectedDate.day,
            _reminderTime!.hour,
            _reminderTime!.minute,
          );
        }

        // 날짜 정규화 (시/분/초 제거) - provider key 일치를 위해
        final normalizedDate = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
        );

        await ref
            .read(dailyTaskViewModelProvider(normalizedDate).notifier)
            .createTask(
              goalId: _selectedGoalId!,
              title: _titleController.text,
              description: _descriptionController.text,
              scheduledDate: normalizedDate,
              reminderTime: reminderDateTime,
              priority: _selectedPriority,
            );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('할일이 추가되었습니다!')),
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
