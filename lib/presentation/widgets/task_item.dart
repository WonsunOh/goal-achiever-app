import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/daily_task.dart';
import '../../data/models/enums.dart';
import '../../core/constants/app_colors.dart';
import '../viewmodels/daily_task_viewmodel.dart';
import 'edit_task_dialog.dart';

class TaskItem extends ConsumerWidget {
  final DailyTask task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: CheckboxListTile(
        value: task.isCompleted,
        onChanged: (value) async {
          await ref
              .read(dailyTaskViewModelProvider(task.scheduledDate).notifier)
              .toggleTaskCompletion(task.id);
        },
        title: Text(
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        secondary: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showTaskOptions(context, ref, task);
          },
        ),
        controlAffinity: ListTileControlAffinity.leading,
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
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('수정'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => EditTaskDialog(task: task),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('삭제', style: TextStyle(color: AppColors.error)),
              onTap: () async {
                Navigator.pop(context);
                await ref
                    .read(dailyTaskViewModelProvider(task.scheduledDate).notifier)
                    .deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
