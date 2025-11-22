import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/goal.dart';
import '../../core/constants/app_colors.dart';
import '../views/goal_detail_view.dart';

class GoalCard extends ConsumerWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    final progressPercent = (goal.progress * 100).toInt();

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoalDetailView(goalId: goal.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(goal.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      goal.category.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          goal.category.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getCategoryColor(goal.category),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (goal.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                    ),
                ],
              ),
              if (goal.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  goal.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$progressPercent% 완료',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        daysLeft > 0 ? 'D-$daysLeft' : '완료!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: daysLeft > 7
                                  ? AppColors.textSecondary
                                  : daysLeft > 0
                                      ? AppColors.warning
                                      : AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getCategoryColor(goal.category),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '목표 기한: ${DateFormat('yyyy.MM.dd').format(goal.targetDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(category) {
    switch (category.toString()) {
      case 'GoalCategory.health':
        return AppColors.healthColor;
      case 'GoalCategory.learning':
        return AppColors.learningColor;
      case 'GoalCategory.finance':
        return AppColors.financeColor;
      case 'GoalCategory.hobby':
        return AppColors.hobbyColor;
      case 'GoalCategory.career':
        return AppColors.careerColor;
      case 'GoalCategory.relationship':
        return AppColors.relationshipColor;
      default:
        return AppColors.otherColor;
    }
  }
}
