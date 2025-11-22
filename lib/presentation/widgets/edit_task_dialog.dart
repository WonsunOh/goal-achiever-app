import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/daily_task.dart';
import '../../data/models/enums.dart';
import '../viewmodels/daily_task_viewmodel.dart';

class EditTaskDialog extends ConsumerStatefulWidget {
  final DailyTask task;

  const EditTaskDialog({super.key, required this.task});

  @override
  ConsumerState<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends ConsumerState<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late Priority _selectedPriority;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _selectedPriority = widget.task.priority;

    if (widget.task.reminderTime != null) {
      _reminderTime = TimeOfDay.fromDateTime(widget.task.reminderTime!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                  '할일 수정',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('yyyy년 MM월 dd일')
                      .format(widget.task.scheduledDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
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
                      initialTime: _reminderTime ?? TimeOfDay.now(),
                    );
                    setState(() {
                      _reminderTime = time;
                    });
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '알림 시간',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _reminderTime != null
                              ? _reminderTime!.format(context)
                              : '알림 없음',
                        ),
                        Row(
                          children: [
                            if (_reminderTime != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _reminderTime = null;
                                  });
                                },
                              ),
                            const Icon(Icons.access_time, size: 16),
                          ],
                        ),
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
                      onPressed: _updateTask,
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

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        DateTime? reminderDateTime;
        if (_reminderTime != null) {
          reminderDateTime = DateTime(
            widget.task.scheduledDate.year,
            widget.task.scheduledDate.month,
            widget.task.scheduledDate.day,
            _reminderTime!.hour,
            _reminderTime!.minute,
          );
        }

        final updatedTask = widget.task.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _selectedPriority,
          reminderTime: reminderDateTime,
        );

        await ref
            .read(dailyTaskViewModelProvider(widget.task.scheduledDate).notifier)
            .updateTask(updatedTask);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('할일이 수정되었습니다!')),
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
