import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../services/statistics_service.dart';
import '../providers/database_provider.dart';
import '../viewmodels/goal_viewmodel.dart';
import '../viewmodels/daily_task_viewmodel.dart';
import '../widgets/stats_charts.dart';

// Statistics service provider
final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService();
});

// Weekly stats provider
final weeklyStatsProvider = FutureProvider<WeeklyStats>((ref) async {
  final taskRepository = ref.watch(dailyTaskRepositoryProvider);
  final statisticsService = ref.watch(statisticsServiceProvider);
  final tasks = await taskRepository.getAllTasks();

  // Get start of current week (Monday)
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final startOfWeek = DateTime(weekStart.year, weekStart.month, weekStart.day);

  return statisticsService.calculateWeeklyStats(startOfWeek, tasks);
});

// Monthly stats provider
final monthlyStatsProvider = FutureProvider<MonthlyStats>((ref) async {
  final taskRepository = ref.watch(dailyTaskRepositoryProvider);
  final statisticsService = ref.watch(statisticsServiceProvider);
  final tasks = await taskRepository.getAllTasks();

  final now = DateTime.now();
  return statisticsService.calculateMonthlyStats(now.year, now.month, tasks);
});

// Category stats provider
final categoryStatsProvider = FutureProvider<List<CategoryStats>>((ref) async {
  final goalRepository = ref.watch(goalRepositoryProvider);
  final taskRepository = ref.watch(dailyTaskRepositoryProvider);
  final statisticsService = ref.watch(statisticsServiceProvider);

  final goals = await goalRepository.getAllGoals();
  final tasks = await taskRepository.getAllTasks();

  return statisticsService.calculateCategoryStats(goals, tasks);
});

// Overall stats provider
final overallStatsProvider = FutureProvider<OverallStats>((ref) async {
  final goalRepository = ref.watch(goalRepositoryProvider);
  final taskRepository = ref.watch(dailyTaskRepositoryProvider);
  final statisticsService = ref.watch(statisticsServiceProvider);

  final goals = await goalRepository.getAllGoals();
  final tasks = await taskRepository.getAllTasks();

  return statisticsService.calculateOverallStats(goals, tasks);
});

// Weekday distribution provider
final weekdayDistributionProvider = FutureProvider<Map<int, int>>((ref) async {
  final taskRepository = ref.watch(dailyTaskRepositoryProvider);
  final statisticsService = ref.watch(statisticsServiceProvider);
  final tasks = await taskRepository.getAllTasks();

  return statisticsService.getWeekdayDistribution(tasks);
});

class StatisticsView extends ConsumerStatefulWidget {
  const StatisticsView({super.key});

  @override
  ConsumerState<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends ConsumerState<StatisticsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '요약'),
            Tab(text: '주간'),
            Tab(text: '월간'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildWeeklyTab(),
          _buildMonthlyTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    final overallStatsAsync = ref.watch(overallStatsProvider);
    final categoryStatsAsync = ref.watch(categoryStatsProvider);
    final weekdayDistAsync = ref.watch(weekdayDistributionProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(overallStatsProvider);
        ref.invalidate(categoryStatsProvider);
        ref.invalidate(weekdayDistributionProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall stats
            overallStatsAsync.when(
              data: (stats) => _buildOverallStatsSection(stats),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('오류: $e'),
            ),
            const SizedBox(height: 24),

            // Category distribution
            _buildSectionHeader('카테고리별 목표'),
            const SizedBox(height: 12),
            categoryStatsAsync.when(
              data: (stats) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CategoryPieChart(categoryStats: stats),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('오류: $e'),
            ),
            const SizedBox(height: 24),

            // Weekday distribution
            _buildSectionHeader('요일별 완료 분포'),
            const SizedBox(height: 12),
            weekdayDistAsync.when(
              data: (dist) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: WeekdayDistributionChart(distribution: dist),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('오류: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStatsSection(OverallStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress gauge
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ProgressGaugeChart(
                        progress: stats.overallCompletionRate,
                        label: '전체 완료율',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  _buildMiniStatCard(
                    '현재 연속',
                    '${stats.currentStreak}일',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _buildMiniStatCard(
                    '최장 연속',
                    '${stats.longestStreak}일',
                    Icons.emoji_events,
                    Colors.amber,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Stats grid
        Row(
          children: [
            Expanded(
              child: StatSummaryCard(
                title: '전체 목표',
                value: '${stats.totalGoals}',
                subtitle: '${stats.completedGoals}개 완료',
                icon: Icons.flag,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatSummaryCard(
                title: '전체 할일',
                value: '${stats.totalTasks}',
                subtitle: '${stats.completedTasks}개 완료',
                icon: Icons.task_alt,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTab() {
    final weeklyStatsAsync = ref.watch(weeklyStatsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(weeklyStatsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: weeklyStatsAsync.when(
          data: (stats) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Week header
              _buildWeekHeader(stats),
              const SizedBox(height: 24),

              // Weekly summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildWeeklyStatCard(
                      '완료율',
                      '${(stats.completionRate * 100).toInt()}%',
                      Icons.percent,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildWeeklyStatCard(
                      '완료 할일',
                      '${stats.completedTasks}/${stats.totalTasks}',
                      Icons.check_circle,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildWeeklyStatCard(
                      '완벽한 날',
                      '${stats.perfectDays}일',
                      Icons.star,
                      Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Weekly chart
              _buildSectionHeader('일별 완료율'),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: WeeklyCompletionChart(dailyStats: stats.dailyStats),
                ),
              ),
              const SizedBox(height: 24),

              // Daily breakdown
              _buildSectionHeader('일별 상세'),
              const SizedBox(height: 12),
              ...stats.dailyStats.map((daily) => _buildDailyCard(daily)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('오류: $e')),
        ),
      ),
    );
  }

  Widget _buildWeekHeader(WeeklyStats stats) {
    final dateFormat = DateFormat('M월 d일');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이번 주',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${dateFormat.format(stats.weekStart)} - ${dateFormat.format(stats.weekEnd)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${(stats.completionRate * 100).toInt()}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCard(DailyStats daily) {
    final isToday = _isToday(daily.date);
    final dateFormat = DateFormat('E', 'ko_KR');

    return Card(
      color: isToday ? AppColors.primary.withValues(alpha: 0.1) : null,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${daily.date.day}',
                style: TextStyle(
                  color: isToday ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                StatisticsService.getWeekdayName(daily.date.weekday),
                style: TextStyle(
                  color: isToday ? Colors.white70 : AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          daily.totalTasks > 0
              ? '${daily.completedTasks}/${daily.totalTasks} 완료'
              : '할일 없음',
        ),
        trailing: daily.totalTasks > 0
            ? CircularProgressIndicator(
                value: daily.completionRate,
                backgroundColor: Colors.grey.shade200,
                color: daily.completionRate == 1.0
                    ? AppColors.success
                    : AppColors.primary,
                strokeWidth: 6,
              )
            : null,
      ),
    );
  }

  Widget _buildMonthlyTab() {
    final monthlyStatsAsync = ref.watch(monthlyStatsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(monthlyStatsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: monthlyStatsAsync.when(
          data: (stats) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month header
              _buildMonthHeader(stats),
              const SizedBox(height: 24),

              // Monthly summary
              Row(
                children: [
                  Expanded(
                    child: _buildWeeklyStatCard(
                      '완료율',
                      '${(stats.completionRate * 100).toInt()}%',
                      Icons.percent,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildWeeklyStatCard(
                      '활동일',
                      '${stats.activeDays}일',
                      Icons.calendar_today,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildWeeklyStatCard(
                      '완벽한 날',
                      '${stats.perfectDays}일',
                      Icons.star,
                      Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Monthly trend chart
              _buildSectionHeader('월간 추이'),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MonthlyTrendChart(dailyStats: stats.dailyStats),
                ),
              ),
              const SizedBox(height: 24),

              // Calendar heatmap
              _buildSectionHeader('달력 보기'),
              const SizedBox(height: 12),
              _buildCalendarHeatmap(stats),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('오류: $e')),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(MonthlyStats stats) {
    final monthNames = ['', '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.indigo.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${stats.year}년 ${monthNames[stats.month]}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${stats.completedTasks}/${stats.totalTasks} 할일 완료',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${(stats.completionRate * 100).toInt()}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeatmap(MonthlyStats stats) {
    final firstDayOfMonth = DateTime(stats.year, stats.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = stats.dailyStats.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['월', '화', '수', '목', '금', '토', '일']
                  .map((day) => SizedBox(
                        width: 36,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: (firstWeekday - 1) + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstWeekday - 1) {
                  return const SizedBox.shrink();
                }

                final dayIndex = index - (firstWeekday - 1);
                if (dayIndex >= daysInMonth) {
                  return const SizedBox.shrink();
                }

                final daily = stats.dailyStats[dayIndex];
                final isToday = _isToday(daily.date);

                Color cellColor;
                if (daily.totalTasks == 0) {
                  cellColor = Colors.grey.shade100;
                } else if (daily.completionRate == 1.0) {
                  cellColor = AppColors.success;
                } else if (daily.completionRate >= 0.5) {
                  cellColor = AppColors.primary.withValues(alpha: 0.6);
                } else if (daily.completionRate > 0) {
                  cellColor = AppColors.primary.withValues(alpha: 0.3);
                } else {
                  cellColor = Colors.red.shade100;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(4),
                    border: isToday
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${dayIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: daily.totalTasks == 0
                            ? AppColors.textTertiary
                            : Colors.white,
                        fontWeight: isToday ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('미완료', Colors.red.shade100),
                const SizedBox(width: 12),
                _buildLegendItem('진행중', AppColors.primary.withValues(alpha: 0.3)),
                const SizedBox(width: 12),
                _buildLegendItem('완료', AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }
}
