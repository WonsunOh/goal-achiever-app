import '../data/models/goal.dart';
import '../data/models/daily_task.dart';
import '../data/models/enums.dart';

// 일별 통계
class DailyStats {
  final DateTime date;
  final int totalTasks;
  final int completedTasks;
  final double completionRate;

  DailyStats({
    required this.date,
    required this.totalTasks,
    required this.completedTasks,
  }) : completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0;

  factory DailyStats.empty(DateTime date) {
    return DailyStats(date: date, totalTasks: 0, completedTasks: 0);
  }
}

// 주간 통계
class WeeklyStats {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DailyStats> dailyStats;
  final int totalTasks;
  final int completedTasks;
  final double completionRate;
  final int perfectDays; // 모든 할일을 완료한 날 수

  WeeklyStats({
    required this.weekStart,
    required this.weekEnd,
    required this.dailyStats,
  })  : totalTasks = dailyStats.fold(0, (sum, d) => sum + d.totalTasks),
        completedTasks = dailyStats.fold(0, (sum, d) => sum + d.completedTasks),
        completionRate = dailyStats.isEmpty
            ? 0
            : dailyStats.fold(0.0, (sum, d) => sum + d.completionRate) /
                dailyStats.length,
        perfectDays = dailyStats
            .where((d) => d.totalTasks > 0 && d.completionRate == 1.0)
            .length;
}

// 월간 통계
class MonthlyStats {
  final int year;
  final int month;
  final List<DailyStats> dailyStats;
  final int totalTasks;
  final int completedTasks;
  final double completionRate;
  final int perfectDays;
  final int activeDays; // 할일이 있었던 날 수

  MonthlyStats({
    required this.year,
    required this.month,
    required this.dailyStats,
  })  : totalTasks = dailyStats.fold(0, (sum, d) => sum + d.totalTasks),
        completedTasks = dailyStats.fold(0, (sum, d) => sum + d.completedTasks),
        completionRate = _calculateCompletionRate(dailyStats),
        perfectDays = dailyStats
            .where((d) => d.totalTasks > 0 && d.completionRate == 1.0)
            .length,
        activeDays = dailyStats.where((d) => d.totalTasks > 0).length;

  static double _calculateCompletionRate(List<DailyStats> dailyStats) {
    final activeDays = dailyStats.where((d) => d.totalTasks > 0).toList();
    if (activeDays.isEmpty) return 0.0;
    return activeDays.fold(0.0, (sum, d) => sum + d.completionRate) / activeDays.length;
  }
}

// 카테고리별 통계
class CategoryStats {
  final GoalCategory category;
  final int totalGoals;
  final int completedGoals;
  final int totalTasks;
  final int completedTasks;
  final double avgProgress;

  CategoryStats({
    required this.category,
    required this.totalGoals,
    required this.completedGoals,
    required this.totalTasks,
    required this.completedTasks,
    required this.avgProgress,
  });
}

// 목표별 통계
class GoalStats {
  final Goal goal;
  final int totalTasks;
  final int completedTasks;
  final double completionRate;
  final int daysRemaining;
  final bool isOnTrack;

  GoalStats({
    required this.goal,
    required this.totalTasks,
    required this.completedTasks,
  })  : completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0,
        daysRemaining = goal.targetDate.difference(DateTime.now()).inDays,
        isOnTrack = _calculateOnTrack(goal, totalTasks, completedTasks);

  static bool _calculateOnTrack(Goal goal, int totalTasks, int completedTasks) {
    if (totalTasks == 0) return true;
    final totalDays = goal.targetDate.difference(goal.createdAt).inDays;
    final elapsedDays = DateTime.now().difference(goal.createdAt).inDays;
    if (totalDays <= 0) return true;
    final expectedProgress = elapsedDays / totalDays;
    final actualProgress = completedTasks / totalTasks;
    return actualProgress >= expectedProgress * 0.8; // 80% 이상이면 순조로움
  }
}

// 전체 통계 요약
class OverallStats {
  final int totalGoals;
  final int completedGoals;
  final int activeGoals;
  final int totalTasks;
  final int completedTasks;
  final int currentStreak;
  final int longestStreak;
  final double overallCompletionRate;
  final Map<GoalCategory, int> goalsByCategory;
  final Map<Priority, int> tasksByPriority;

  OverallStats({
    required this.totalGoals,
    required this.completedGoals,
    required this.activeGoals,
    required this.totalTasks,
    required this.completedTasks,
    required this.currentStreak,
    required this.longestStreak,
    required double completionRate,
    required this.goalsByCategory,
    required this.tasksByPriority,
  }) : overallCompletionRate = completionRate.isNaN || completionRate.isInfinite ? 0.0 : completionRate;
}

class StatisticsService {
  // 일별 통계 계산
  DailyStats calculateDailyStats(DateTime date, List<DailyTask> tasks) {
    final dayTasks = tasks.where((t) {
      final taskDate = DateTime(t.scheduledDate.year, t.scheduledDate.month, t.scheduledDate.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      return taskDate == targetDate;
    }).toList();

    return DailyStats(
      date: date,
      totalTasks: dayTasks.length,
      completedTasks: dayTasks.where((t) => t.isCompleted).length,
    );
  }

  // 주간 통계 계산
  WeeklyStats calculateWeeklyStats(DateTime weekStart, List<DailyTask> tasks) {
    final dailyStats = <DailyStats>[];

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      dailyStats.add(calculateDailyStats(date, tasks));
    }

    return WeeklyStats(
      weekStart: weekStart,
      weekEnd: weekStart.add(const Duration(days: 6)),
      dailyStats: dailyStats,
    );
  }

  // 월간 통계 계산
  MonthlyStats calculateMonthlyStats(int year, int month, List<DailyTask> tasks) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final dailyStats = <DailyStats>[];

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(year, month, i);
      dailyStats.add(calculateDailyStats(date, tasks));
    }

    return MonthlyStats(
      year: year,
      month: month,
      dailyStats: dailyStats,
    );
  }

  // 최근 N일 통계
  List<DailyStats> getRecentDailyStats(int days, List<DailyTask> tasks) {
    final stats = <DailyStats>[];
    final today = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      stats.add(calculateDailyStats(date, tasks));
    }

    return stats;
  }

  // 카테고리별 통계 계산
  List<CategoryStats> calculateCategoryStats(
    List<Goal> goals,
    List<DailyTask> tasks,
  ) {
    final categoryMap = <GoalCategory, List<Goal>>{};

    for (final category in GoalCategory.values) {
      categoryMap[category] = goals.where((g) => g.category == category).toList();
    }

    return categoryMap.entries.map((entry) {
      final categoryGoals = entry.value;
      final goalIds = categoryGoals.map((g) => g.id).toSet();
      final categoryTasks = tasks.where((t) =>
        t.goalId != null && goalIds.contains(t.goalId)).toList();

      final totalProgress = categoryGoals.isEmpty
          ? 0.0
          : categoryGoals.fold(0.0, (sum, g) => sum + g.progress) /
              categoryGoals.length;

      return CategoryStats(
        category: entry.key,
        totalGoals: categoryGoals.length,
        completedGoals: categoryGoals.where((g) => g.isCompleted).length,
        totalTasks: categoryTasks.length,
        completedTasks: categoryTasks.where((t) => t.isCompleted).length,
        avgProgress: totalProgress,
      );
    }).where((s) => s.totalGoals > 0).toList();
  }

  // 목표별 통계 계산
  List<GoalStats> calculateGoalStats(List<Goal> goals, List<DailyTask> tasks) {
    return goals.map((goal) {
      final goalTasks = tasks.where((t) => t.goalId == goal.id).toList();
      return GoalStats(
        goal: goal,
        totalTasks: goalTasks.length,
        completedTasks: goalTasks.where((t) => t.isCompleted).length,
      );
    }).toList();
  }

  // 연속 달성일 계산
  int calculateStreak(List<DailyTask> tasks) {
    int streak = 0;
    final today = DateTime.now();
    var checkDate = DateTime(today.year, today.month, today.day);

    while (true) {
      final dayTasks = tasks.where((t) {
        final taskDate = DateTime(t.scheduledDate.year, t.scheduledDate.month, t.scheduledDate.day);
        return taskDate == checkDate;
      }).toList();

      if (dayTasks.isEmpty) {
        // 오늘이고 할일이 없으면 계속 체크
        if (checkDate == DateTime(today.year, today.month, today.day)) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }

      final allCompleted = dayTasks.every((t) => t.isCompleted);
      if (!allCompleted) {
        // 오늘이고 아직 완료 안됐으면 어제부터 체크
        if (checkDate == DateTime(today.year, today.month, today.day)) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }

      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  // 최장 연속 달성일 계산
  int calculateLongestStreak(List<DailyTask> tasks) {
    if (tasks.isEmpty) return 0;

    // 모든 날짜 가져오기
    final dates = tasks.map((t) => DateTime(t.scheduledDate.year, t.scheduledDate.month, t.scheduledDate.day)).toSet().toList();
    dates.sort();

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final date in dates) {
      final dayTasks = tasks.where((t) {
        final taskDate = DateTime(t.scheduledDate.year, t.scheduledDate.month, t.scheduledDate.day);
        return taskDate == date;
      }).toList();

      if (dayTasks.isEmpty) continue;

      final allCompleted = dayTasks.every((t) => t.isCompleted);

      if (allCompleted) {
        if (lastDate != null && date.difference(lastDate!).inDays == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
        longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
        lastDate = date;
      } else {
        currentStreak = 0;
        lastDate = null;
      }
    }

    return longestStreak;
  }

  // 전체 통계 요약
  OverallStats calculateOverallStats(List<Goal> goals, List<DailyTask> tasks) {
    final goalsByCategory = <GoalCategory, int>{};
    for (final category in GoalCategory.values) {
      final count = goals.where((g) => g.category == category).length;
      if (count > 0) goalsByCategory[category] = count;
    }

    final tasksByPriority = <Priority, int>{};
    for (final priority in Priority.values) {
      final count = tasks.where((t) => t.priority == priority).length;
      if (count > 0) tasksByPriority[priority] = count;
    }

    final completedTasks = tasks.where((t) => t.isCompleted).length;

    return OverallStats(
      totalGoals: goals.length,
      completedGoals: goals.where((g) => g.isCompleted).length,
      activeGoals: goals.where((g) => !g.isCompleted).length,
      totalTasks: tasks.length,
      completedTasks: completedTasks,
      currentStreak: calculateStreak(tasks),
      longestStreak: calculateLongestStreak(tasks),
      completionRate: tasks.isEmpty ? 0.0 : completedTasks / tasks.length,
      goalsByCategory: goalsByCategory,
      tasksByPriority: tasksByPriority,
    );
  }

  // 시간대별 할일 완료 분포
  Map<int, int> getHourlyDistribution(List<DailyTask> tasks) {
    final distribution = <int, int>{};
    for (int i = 0; i < 24; i++) {
      distribution[i] = 0;
    }

    for (final task in tasks.where((t) => t.isCompleted && t.completedAt != null)) {
      final hour = task.completedAt!.hour;
      distribution[hour] = (distribution[hour] ?? 0) + 1;
    }

    return distribution;
  }

  // 요일별 할일 완료 분포
  Map<int, int> getWeekdayDistribution(List<DailyTask> tasks) {
    final distribution = <int, int>{};
    for (int i = 1; i <= 7; i++) {
      distribution[i] = 0;
    }

    for (final task in tasks.where((t) => t.isCompleted)) {
      final weekday = task.scheduledDate.weekday;
      distribution[weekday] = (distribution[weekday] ?? 0) + 1;
    }

    return distribution;
  }

  // 요일 이름 가져오기
  static String getWeekdayName(int weekday) {
    const names = ['', '월', '화', '수', '목', '금', '토', '일'];
    return names[weekday];
  }
}
