import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/daily_task.dart';
import '../../data/models/enums.dart';
import '../../data/models/badge.dart';
import '../providers/database_provider.dart';

part 'daily_task_viewmodel.g.dart';

@riverpod
class DailyTaskViewModel extends _$DailyTaskViewModel {
  final _uuid = const Uuid();

  @override
  Stream<List<DailyTask>> build(DateTime date) {
    final repository = ref.watch(dailyTaskRepositoryProvider);
    return repository.watchTasksByDate(date);
  }

  Future<void> createTask({
    required String goalId,
    required String title,
    required String description,
    required DateTime scheduledDate,
    DateTime? reminderTime,
    Priority priority = Priority.medium,
  }) async {
    final repository = ref.read(dailyTaskRepositoryProvider);
    final notificationService = ref.read(notificationServiceProvider);

    final taskId = _uuid.v4();
    final task = DailyTask(
      id: taskId,
      goalId: goalId,
      title: title,
      description: description,
      scheduledDate: scheduledDate,
      reminderTime: reminderTime,
      priority: priority,
      createdAt: DateTime.now(),
    );

    await repository.createTask(task);

    // Schedule reminder if set
    if (reminderTime != null && reminderTime.isAfter(DateTime.now())) {
      await notificationService.scheduleTaskReminder(
        taskId: taskId,
        taskTitle: title,
        reminderTime: reminderTime,
      );
    }
  }

  Future<void> updateTask(DailyTask task) async {
    final repository = ref.read(dailyTaskRepositoryProvider);
    final notificationService = ref.read(notificationServiceProvider);

    await repository.updateTask(task);

    // Cancel existing reminder
    await notificationService.cancelTaskReminder(task.id);

    // Schedule new reminder if set
    if (task.reminderTime != null && task.reminderTime!.isAfter(DateTime.now())) {
      await notificationService.scheduleTaskReminder(
        taskId: task.id,
        taskTitle: task.title,
        reminderTime: task.reminderTime!,
      );
    }
  }

  Future<void> deleteTask(String id) async {
    final repository = ref.read(dailyTaskRepositoryProvider);
    final notificationService = ref.read(notificationServiceProvider);

    await repository.deleteTask(id);
    await notificationService.cancelTaskReminder(id);
  }

  /// 할일 완료 토글 - 획득한 배지 목록 반환
  Future<List<Badge>> toggleTaskCompletion(String id) async {
    final repository = ref.read(dailyTaskRepositoryProvider);
    final notificationService = ref.read(notificationServiceProvider);
    final badgeService = await ref.read(badgeServiceProvider.future);
    final unlockedBadges = <Badge>[];

    // 현재 상태 확인 (완료 토글 전)
    final allTasks = await repository.getAllTasks();
    final taskBefore = allTasks.where((t) => t.id == id).firstOrNull;
    final wasCompleted = taskBefore?.isCompleted ?? false;

    await repository.toggleTaskCompletion(id);

    // 통계 갱신을 위해 invalidate
    ref.invalidate(taskStatisticsProvider);

    // Get the task to check its goalId and update progress
    final tasks = await repository.getAllTasks();
    final task = tasks.where((t) => t.id == id).firstOrNull;

    if (task != null) {
      // Cancel reminder if completed
      if (task.isCompleted) {
        await notificationService.cancelTaskReminder(id);

        // 할일 완료 시 배지 체크 (완료되지 않았던 것이 완료된 경우에만)
        if (!wasCompleted) {
          final taskBadges = await badgeService.onTaskCompleted();
          unlockedBadges.addAll(taskBadges);

          // 연속 달성 체크
          final streak = await _calculateCurrentStreak();
          final streakBadges = await badgeService.onStreakUpdated(streak);
          unlockedBadges.addAll(streakBadges);
        }
      }

      // Update goal progress (목표 완료 배지도 체크)
      final goalBadges = await _updateGoalProgress(task.goalId);
      unlockedBadges.addAll(goalBadges);
    }

    return unlockedBadges;
  }

  Future<int> _calculateCurrentStreak() async {
    final repository = ref.read(dailyTaskRepositoryProvider);
    final allTasks = await repository.getAllTasks();

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    int streak = 0;
    var checkDate = todayStart;

    while (true) {
      final dayTasks = allTasks.where((t) {
        final taskDate = DateTime(
            t.scheduledDate.year, t.scheduledDate.month, t.scheduledDate.day);
        return taskDate.isAtSameMomentAs(checkDate);
      }).toList();

      if (dayTasks.isEmpty) break;

      final allCompleted = dayTasks.every((t) => t.isCompleted);
      if (!allCompleted) break;

      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Future<List<Badge>> _updateGoalProgress(String goalId) async {
    final taskRepository = ref.read(dailyTaskRepositoryProvider);
    final goalRepository = ref.read(goalRepositoryProvider);
    final badgeService = await ref.read(badgeServiceProvider.future);
    final unlockedBadges = <Badge>[];

    // Get all tasks for this goal
    final tasks = await taskRepository.getTasksByGoalId(goalId);

    if (tasks.isEmpty) return unlockedBadges;

    // Calculate progress
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final totalTasks = tasks.length;
    final progress = completedTasks / totalTasks;

    // 기존 목표 상태 확인 (완료 여부)
    final goalBefore = await goalRepository.getGoalById(goalId);
    final wasCompleted = goalBefore?.isCompleted ?? false;

    // Update goal progress
    await goalRepository.updateGoalProgress(goalId, progress);

    // Show notification if milestone reached
    final notificationService = ref.read(notificationServiceProvider);
    final goal = await goalRepository.getGoalById(goalId);

    if (goal != null) {
      final progressPercent = (progress * 100).toInt();

      // Check for milestones
      if (progressPercent == 25 ||
          progressPercent == 50 ||
          progressPercent == 75 ||
          progressPercent == 100) {
        await notificationService.showProgressNotification(
          goalTitle: goal.title,
          progress: progressPercent,
        );
      }

      // 목표 완료 시 배지 체크 (100% 달성 시)
      if (progress >= 1.0 && !wasCompleted) {
        final goalBadges = await badgeService.onGoalCompleted();
        unlockedBadges.addAll(goalBadges);
      }
    }

    return unlockedBadges;
  }
}

@riverpod
Future<List<DailyTask>> tasksByGoalId(TasksByGoalIdRef ref, String goalId) async {
  final repository = ref.watch(dailyTaskRepositoryProvider);
  return repository.getTasksByGoalId(goalId);
}

@riverpod
Stream<List<DailyTask>> todayTasks(TodayTasksRef ref) {
  final repository = ref.watch(dailyTaskRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return repository.watchTasksByDate(today);
}

// Provider for task completion statistics
@riverpod
Future<TaskStatistics> taskStatistics(TaskStatisticsRef ref) async {
  final repository = ref.watch(dailyTaskRepositoryProvider);
  final allTasks = await repository.getAllTasks();

  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = todayStart.add(const Duration(days: 1));

  // 오늘 날짜에 해당하는 할일 (자정 포함, 다음날 자정 전까지)
  final todayTasks = allTasks.where((t) {
    final taskDate = DateTime(t.scheduledDate.year, t.scheduledDate.month, t.scheduledDate.day);
    return taskDate.isAtSameMomentAs(todayStart);
  }).toList();

  final completedToday = todayTasks.where((t) => t.isCompleted).length;
  final totalToday = todayTasks.length;

  // Calculate streak
  int streak = 0;
  var checkDate = todayStart;

  while (true) {
    final dayTasks = allTasks.where((t) {
      final taskDate = DateTime(
          t.scheduledDate.year, t.scheduledDate.month, t.scheduledDate.day);
      return taskDate.isAtSameMomentAs(checkDate);
    }).toList();

    if (dayTasks.isEmpty) break;

    final allCompleted = dayTasks.every((t) => t.isCompleted);
    if (!allCompleted) break;

    streak++;
    checkDate = checkDate.subtract(const Duration(days: 1));
  }

  return TaskStatistics(
    completedToday: completedToday,
    totalToday: totalToday,
    streak: streak,
  );
}

class TaskStatistics {
  final int completedToday;
  final int totalToday;
  final int streak;

  TaskStatistics({
    required this.completedToday,
    required this.totalToday,
    required this.streak,
  });

  double get todayProgress =>
      totalToday > 0 ? completedToday / totalToday : 0.0;
}
