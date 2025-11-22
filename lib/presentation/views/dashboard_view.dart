import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodels/goal_viewmodel.dart';
import '../viewmodels/daily_task_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/goal_card.dart';
import '../widgets/task_item.dart';
import '../widgets/motivation_card.dart';
import 'settings_view.dart';
import 'achievements_view.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalViewModelProvider);
    final todayTasksAsync = ref.watch(todayTasksProvider);
    final statsAsync = ref.watch(taskStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Goal Achiever'),
            Text(
              DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AchievementsView()),
              );
            },
            tooltip: '업적',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(goalViewModelProvider);
          ref.invalidate(todayTasksProvider);
          ref.invalidate(taskStatisticsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MotivationCard(),
              const SizedBox(height: 16),
              _buildStatsRow(context, ref, statsAsync, todayTasksAsync),
              const SizedBox(height: 24),
              _buildTodayTasksSection(context, ref, todayTasksAsync),
              const SizedBox(height: 24),
              _buildActiveGoalsSection(context, ref, goalsAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<TaskStatistics> statsAsync,
    AsyncValue todayTasksAsync,
  ) {
    return statsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.local_fire_department,
                iconColor: Colors.orange,
                value: '${stats.streak}',
                label: '연속 달성',
                suffix: '일',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.check_circle,
                iconColor: AppColors.success,
                value: '${stats.completedToday}/${stats.totalToday}',
                label: '오늘 완료',
                suffix: '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.trending_up,
                iconColor: AppColors.primary,
                value: '${(stats.todayProgress * 100).toInt()}',
                label: '달성률',
                suffix: '%',
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required String suffix,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (suffix.isNotEmpty)
                  Text(
                    suffix,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTasksSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue todayTasksAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '오늘의 할일',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton.icon(
              onPressed: () {
                ref.read(selectedIndexProvider.notifier).state = 2;
              },
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('더보기'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        todayTasksAsync.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '오늘 등록된 할일이 없습니다',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final incompleteTasks = tasks.where((t) => !t.isCompleted).toList();
            final displayTasks = incompleteTasks.take(3).toList();

            return Column(
              children: [
                ...displayTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TaskItem(task: task),
                  ),
                ),
                if (incompleteTasks.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '외 ${incompleteTasks.length - 3}개',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('오류: $error'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveGoalsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue goalsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '진행 중인 목표',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton.icon(
              onPressed: () {
                ref.read(selectedIndexProvider.notifier).state = 1;
              },
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('더보기'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        goalsAsync.when(
          data: (goals) {
            final activeGoals = goals.where((g) => !g.isCompleted).toList();

            if (activeGoals.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '진행 중인 목표가 없습니다',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final displayGoals = activeGoals.take(2).toList();

            return Column(
              children: [
                ...displayGoals.map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GoalCard(goal: goal),
                  ),
                ),
                if (activeGoals.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '외 ${activeGoals.length - 2}개',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('오류: $error'),
            ),
          ),
        ),
      ],
    );
  }
}

final selectedIndexProvider = StateProvider<int>((ref) => 0);
