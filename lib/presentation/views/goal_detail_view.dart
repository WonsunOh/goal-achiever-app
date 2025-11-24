import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/goal.dart';
import '../../data/models/enums.dart';
import '../../core/constants/app_colors.dart';
import '../viewmodels/goal_viewmodel.dart';
import '../viewmodels/daily_task_viewmodel.dart';
import '../widgets/task_item.dart';
import '../widgets/create_task_dialog.dart';
import '../widgets/edit_goal_dialog.dart';

class GoalDetailView extends ConsumerWidget {
  final String goalId;

  const GoalDetailView({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalByIdProvider(goalId));

    return goalAsync.when(
      data: (goal) {
        if (goal == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('목표')),
            body: const Center(child: Text('목표를 찾을 수 없습니다')),
          );
        }
        return _buildContent(context, ref, goal);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('오류')),
        body: Center(child: Text('오류: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Goal goal) {
    final tasksAsync = ref.watch(tasksByGoalIdProvider(goalId));
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    final progressPercent = (goal.progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('목표 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditGoalDialog(goal: goal),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context, ref, goal),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goal Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(goal.category)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            goal.category.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.title,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(goal.category)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  goal.category.displayName,
                                  style: TextStyle(
                                    color: _getCategoryColor(goal.category),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (goal.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        goal.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                    if (goal.motivationQuote.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.format_quote,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                goal.motivationQuote,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Progress Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '진행률',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$progressPercent%',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getCategoryColor(goal.category),
                              ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              daysLeft > 0
                                  ? 'D-$daysLeft'
                                  : daysLeft == 0
                                      ? 'D-Day'
                                      : '기한 초과',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: daysLeft > 7
                                        ? AppColors.textSecondary
                                        : daysLeft > 0
                                            ? AppColors.warning
                                            : AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              DateFormat('yyyy.MM.dd').format(goal.targetDate),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: goal.progress,
                        minHeight: 16,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCategoryColor(goal.category),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '시작: ${DateFormat('MM.dd').format(goal.startDate)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '목표: ${DateFormat('MM.dd').format(goal.targetDate)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '연결된 할일',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateTaskDialog(
                        selectedDate: DateTime.now(),
                        preSelectedGoalId: goalId,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('할일 추가'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.task_alt_outlined,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '연결된 할일이 없습니다',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final incompleteTasks =
                    tasks.where((t) => !t.isCompleted).toList();
                final completedTasks =
                    tasks.where((t) => t.isCompleted).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (incompleteTasks.isNotEmpty) ...[
                      Text(
                        '미완료 (${incompleteTasks.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...incompleteTasks.map(
                        (task) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TaskItem(task: task),
                        ),
                      ),
                    ],
                    if (completedTasks.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        '완료됨 (${completedTasks.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...completedTasks.map(
                        (task) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TaskItem(task: task),
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('오류: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(GoalCategory category) {
    switch (category) {
      case GoalCategory.health:
        return AppColors.healthColor;
      case GoalCategory.exercise:
        return AppColors.exerciseColor;
      case GoalCategory.learning:
        return AppColors.learningColor;
      case GoalCategory.finance:
        return AppColors.financeColor;
      case GoalCategory.hobby:
        return AppColors.hobbyColor;
      case GoalCategory.career:
        return AppColors.careerColor;
      case GoalCategory.relationship:
        return AppColors.relationshipColor;
      case GoalCategory.other:
        return AppColors.otherColor;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('목표 삭제'),
        content: Text('\'${goal.title}\' 목표를 삭제하시겠습니까?\n연결된 할일도 함께 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(goalViewModelProvider.notifier).deleteGoal(goal.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
