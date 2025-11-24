import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/daily_task.dart';
import '../../core/constants/app_colors.dart';
import '../viewmodels/daily_task_viewmodel.dart';
import 'celebration_overlay.dart';
import 'badge_unlock_dialog.dart';

class CompleteTaskDialog extends ConsumerStatefulWidget {
  final DailyTask task;

  const CompleteTaskDialog({super.key, required this.task});

  @override
  ConsumerState<CompleteTaskDialog> createState() => _CompleteTaskDialogState();
}

class _CompleteTaskDialogState extends ConsumerState<CompleteTaskDialog> {
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
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '할일 완료',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '수고하셨습니다! 소감을 남겨보세요.',
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
                    labelText: '실행 소감 (선택)',
                    hintText: '어떻게 진행했나요? 느낀 점이 있나요?',
                    prefixIcon: Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 8),

                // 힌트 텍스트
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '소감을 기록하면 나중에 돌아볼 때 도움이 됩니다',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _completeTask,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: const Text('완료하기'),
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

  Future<void> _completeTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Navigator context를 미리 저장
    final navigatorContext = Navigator.of(context).context;

    try {
      // 날짜 정규화
      final normalizedDate = DateTime(
        widget.task.scheduledDate.year,
        widget.task.scheduledDate.month,
        widget.task.scheduledDate.day,
      );

      // 할일 업데이트 (제목, 메모 포함)
      final updatedTask = widget.task.copyWith(
        title: _titleController.text,
        completionNote: _noteController.text.isEmpty ? null : _noteController.text,
      );

      await ref
          .read(dailyTaskViewModelProvider(normalizedDate).notifier)
          .updateTask(updatedTask);

      // 완료 토글
      final unlockedBadges = await ref
          .read(dailyTaskViewModelProvider(normalizedDate).notifier)
          .toggleTaskCompletion(widget.task.id);

      if (mounted) {
        Navigator.pop(context, true);
      }

      // 축하 효과 표시
      if (navigatorContext.mounted) {
        await showCelebration(navigatorContext, message: '할일 완료!');

        // 배지 획득 시 팝업 표시
        if (unlockedBadges.isNotEmpty && navigatorContext.mounted) {
          await showBadgeUnlockDialogs(navigatorContext, unlockedBadges);
        }
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

/// 할일 완료 다이얼로그를 표시하고 결과를 반환
Future<bool> showCompleteTaskDialog(BuildContext context, DailyTask task) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => CompleteTaskDialog(task: task),
  );
  return result ?? false;
}
