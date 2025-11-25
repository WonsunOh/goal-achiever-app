import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/daily_task.dart';
import '../../data/models/enums.dart';
import '../../core/constants/app_colors.dart';
import '../viewmodels/daily_task_viewmodel.dart';
import 'edit_task_dialog.dart';
import 'complete_task_dialog.dart';
import 'edit_completion_dialog.dart';

class TaskItem extends ConsumerWidget {
  final DailyTask task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 날짜가 지났는지 확인
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(
      task.scheduledDate.year,
      task.scheduledDate.month,
      task.scheduledDate.day,
    );
    final isOverdue = !task.isCompleted && taskDate.isBefore(today);

    return Card(
      child: InkWell(
        onTap: () {
          if (!task.isCompleted) {
            // 미완료 상태: 완료 다이얼로그 표시
            showCompleteTaskDialog(context, task);
          } else {
            // 완료 상태: 소감 보기 다이얼로그
            _showCompletedTaskDetail(context);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 완료 상태 아이콘
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : isOverdue
                          ? AppColors.error.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  task.isCompleted
                      ? Icons.check
                      : isOverdue
                          ? Icons.close
                          : Icons.radio_button_unchecked,
                  size: 20,
                  color: task.isCompleted
                      ? AppColors.success
                      : isOverdue
                          ? AppColors.error
                          : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              // 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task.isCompleted
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                          ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // 완료 소감 표시
                    if (task.isCompleted && task.completionNote != null && task.completionNote!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.format_quote,
                              size: 12,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                task.completionNote!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.success,
                                      fontStyle: FontStyle.italic,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPriorityChip(context, task.priority),
                        if (task.reminderTime != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.notifications_outlined,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('HH:mm').format(task.reminderTime!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // 더보기 버튼
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  _showTaskOptions(context, ref, task);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompletedTaskDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(sheetContext).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 핸들
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 완료 배지 + 수정 버튼
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '완료됨',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (task.completedAt != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MM/dd HH:mm').format(task.completedAt!),
                    style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                ],
                const Spacer(),
                // 수정 버튼
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    showEditCompletionDialog(context, task);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('수정'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 제목
            Text(
              task.title,
              style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description,
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
            // 소감
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '실행 소감',
                        style: Theme.of(sheetContext).textTheme.labelMedium?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (task.completionNote != null && task.completionNote!.isNotEmpty)
                        ? task.completionNote!
                        : '소감이 없습니다. 수정 버튼을 눌러 소감을 추가해보세요.',
                    style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: (task.completionNote != null && task.completionNote!.isNotEmpty)
                              ? null
                              : AppColors.textTertiary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(BuildContext context, Priority priority) {
    Color color;
    String label;

    switch (priority) {
      case Priority.high:
        color = AppColors.highPriority;
        label = '높음';
        break;
      case Priority.medium:
        color = AppColors.mediumPriority;
        label = '보통';
        break;
      case Priority.low:
        color = AppColors.lowPriority;
        label = '낮음';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showTaskOptions(BuildContext context, WidgetRef ref, DailyTask task) {
    final normalizedDate = DateTime(
      task.scheduledDate.year,
      task.scheduledDate.month,
      task.scheduledDate.day,
    );

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 완료 여부에 따라 다른 수정 옵션
            if (task.isCompleted) ...[
              // 완료된 할일: 소감 수정
              ListTile(
                leading: const Icon(Icons.edit_note),
                title: const Text('소감 수정'),
                subtitle: const Text('제목과 실행 소감을 수정합니다'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showEditCompletionDialog(context, task);
                },
              ),
              // 완료 취소
              ListTile(
                leading: Icon(Icons.undo, color: Colors.orange.shade700),
                title: Text('완료 취소', style: TextStyle(color: Colors.orange.shade700)),
                subtitle: const Text('할일을 미완료 상태로 되돌립니다'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await ref
                      .read(dailyTaskViewModelProvider(normalizedDate).notifier)
                      .toggleTaskCompletion(task.id);
                },
              ),
            ] else ...[
              // 미완료 할일: 일반 수정
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('수정'),
                subtitle: const Text('할일 내용을 수정합니다'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showDialog(
                    context: context,
                    builder: (context) => EditTaskDialog(task: task),
                  );
                },
              ),
              // 바로 완료 (소감 없이)
              ListTile(
                leading: Icon(Icons.check_circle_outline, color: AppColors.success),
                title: Text('바로 완료', style: TextStyle(color: AppColors.success)),
                subtitle: const Text('소감 없이 바로 완료 처리합니다'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await ref
                      .read(dailyTaskViewModelProvider(normalizedDate).notifier)
                      .toggleTaskCompletion(task.id);
                },
              ),
            ],
            const Divider(),
            // 다른 날짜로 복사
            ListTile(
              leading: const Icon(Icons.copy, color: AppColors.primary),
              title: const Text('다른 날로 복사'),
              subtitle: const Text('이 할일을 다른 날짜로 복사합니다'),
              onTap: () async {
                Navigator.pop(sheetContext);
                // 날짜 선택 다이얼로그
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null && context.mounted) {
                  final normalizedSelectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  );
                  await ref
                      .read(dailyTaskViewModelProvider(normalizedDate).notifier)
                      .copyTask(
                        originalTask: task,
                        newDate: normalizedSelectedDate,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${selectedDate.month}월 ${selectedDate.day}일로 복사되었습니다',
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            // 삭제 (공통)
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('삭제', style: TextStyle(color: AppColors.error)),
              onTap: () async {
                Navigator.pop(sheetContext);
                await ref
                    .read(dailyTaskViewModelProvider(normalizedDate).notifier)
                    .deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
