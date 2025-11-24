import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/daily_task.dart';
import '../../core/constants/app_colors.dart';
import '../viewmodels/daily_task_viewmodel.dart';

class EditCompletionDialog extends ConsumerStatefulWidget {
  final DailyTask task;

  const EditCompletionDialog({super.key, required this.task});

  @override
  ConsumerState<EditCompletionDialog> createState() => _EditCompletionDialogState();
}

class _EditCompletionDialogState extends ConsumerState<EditCompletionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.completionNote ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
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
                // 헤더
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit_note,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '소감 수정',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '완료한 할일의 소감을 수정합니다.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 제목 수정
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '할일 제목',
                    hintText: '제목을 수정할 수 있습니다',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 완료 메모/소감
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: '실행 소감',
                    hintText: '어떻게 진행했나요? 느낀 점이 있나요?',
                    prefixIcon: Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 24),

                // 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _saveChanges,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: const Text('저장'),
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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 날짜 정규화
      final normalizedDate = DateTime(
        widget.task.scheduledDate.year,
        widget.task.scheduledDate.month,
        widget.task.scheduledDate.day,
      );

      // 할일 업데이트
      final updatedTask = widget.task.copyWith(
        title: _titleController.text,
        completionNote: _noteController.text.isEmpty ? null : _noteController.text,
      );

      await ref
          .read(dailyTaskViewModelProvider(normalizedDate).notifier)
          .updateTask(updatedTask);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('소감이 수정되었습니다!')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    }
  }
}

/// 소감 수정 다이얼로그를 표시
Future<bool> showEditCompletionDialog(BuildContext context, DailyTask task) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => EditCompletionDialog(task: task),
  );
  return result ?? false;
}
