import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/goal.dart';
import '../../data/models/daily_task.dart';
import '../../data/models/enums.dart';
import '../../data/models/badge.dart';
import '../providers/database_provider.dart';

part 'goal_viewmodel.g.dart';

@riverpod
class GoalViewModel extends _$GoalViewModel {
  final _uuid = const Uuid();

  @override
  Stream<List<Goal>> build() {
    final repository = ref.watch(goalRepositoryProvider);
    return repository.watchAllGoals();
  }

  /// 목표 생성 - 획득한 배지 반환
  Future<Badge?> createGoal({
    required String title,
    required String description,
    required GoalCategory category,
    required DateTime startDate,
    required DateTime targetDate,
    String motivationQuote = '',
    List<int> recurringDays = const [],
    DateTime? reminderTime,
  }) async {
    final repository = ref.read(goalRepositoryProvider);
    final goalId = _uuid.v4();
    final goal = Goal(
      id: goalId,
      title: title,
      description: description,
      category: category,
      startDate: startDate,
      targetDate: targetDate,
      motivationQuote: motivationQuote,
      recurringDays: recurringDays,
      reminderTime: reminderTime,
      createdAt: DateTime.now(),
    );

    await repository.createGoal(goal);

    // 목표 생성 시 배지 체크
    final badgeService = await ref.read(badgeServiceProvider.future);
    final unlockedBadge = await badgeService.onGoalCreated();

    // 반복 요일이 설정된 경우 자동으로 할일 생성
    if (recurringDays.isNotEmpty) {
      await _createRecurringTasks(
        goalId: goalId,
        goalTitle: title,
        startDate: startDate,
        targetDate: targetDate,
        recurringDays: recurringDays,
        reminderTime: reminderTime,
      );
    }

    return unlockedBadge;
  }

  /// 반복 요일에 해당하는 날짜들에 할일을 자동 생성
  Future<void> _createRecurringTasks({
    required String goalId,
    required String goalTitle,
    required DateTime startDate,
    required DateTime targetDate,
    required List<int> recurringDays,
    DateTime? reminderTime,
  }) async {
    final taskRepository = ref.read(dailyTaskRepositoryProvider);

    // 시작일부터 목표일까지 반복
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final endDate = DateTime(targetDate.year, targetDate.month, targetDate.day);

    while (!currentDate.isAfter(endDate)) {
      // currentDate의 요일이 선택된 요일 목록에 포함되어 있는지 확인
      // DateTime.weekday: 1=월, 2=화, ..., 7=일
      if (recurringDays.contains(currentDate.weekday)) {
        // 알림 시간을 해당 날짜에 맞게 설정
        DateTime? taskReminderTime;
        if (reminderTime != null) {
          taskReminderTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            reminderTime.hour,
            reminderTime.minute,
          );
        }

        final task = DailyTask(
          id: _uuid.v4(),
          goalId: goalId,
          title: goalTitle,
          description: '',
          scheduledDate: currentDate,
          priority: Priority.medium,
          reminderTime: taskReminderTime,
          createdAt: DateTime.now(),
        );
        await taskRepository.createTask(task);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  Future<void> updateGoal(Goal goal, {Goal? oldGoal}) async {
    final repository = ref.read(goalRepositoryProvider);

    // 기존 목표 정보 가져오기 (oldGoal이 없으면 DB에서 조회)
    final previousGoal = oldGoal ?? await repository.getGoalById(goal.id);

    await repository.updateGoal(goal);

    // 실행주기가 변경되었는지 확인
    if (previousGoal != null && goal.recurringDays.isNotEmpty) {
      final oldDays = previousGoal.recurringDays.toSet();
      final newDays = goal.recurringDays.toSet();

      // 새로 추가된 요일이 있으면 할일 생성
      final addedDays = newDays.difference(oldDays);
      if (addedDays.isNotEmpty) {
        await _createRecurringTasks(
          goalId: goal.id,
          goalTitle: goal.title,
          startDate: DateTime.now(), // 오늘부터 생성
          targetDate: goal.targetDate,
          recurringDays: addedDays.toList(),
          reminderTime: goal.reminderTime,
        );
      }
    }
  }

  Future<void> deleteGoal(String id) async {
    final repository = ref.read(goalRepositoryProvider);
    final taskRepository = ref.read(dailyTaskRepositoryProvider);
    final achievementRepository = ref.read(achievementRepositoryProvider);

    // 연관된 할일과 성취 먼저 삭제
    await taskRepository.deleteTasksByGoalId(id);
    await achievementRepository.deleteAchievementsByGoalId(id);

    // 목표 삭제
    await repository.deleteGoal(id);
  }

  Future<void> updateProgress(String id, double progress) async {
    final repository = ref.read(goalRepositoryProvider);
    await repository.updateGoalProgress(id, progress);
  }

  Future<void> completeGoal(String id) async {
    final repository = ref.read(goalRepositoryProvider);
    final goal = await repository.getGoalById(id);
    if (goal != null) {
      final updatedGoal = goal.copyWith(
        isCompleted: true,
        progress: 1.0,
        completedAt: DateTime.now(),
      );
      await repository.updateGoal(updatedGoal);
    }
  }
}

@riverpod
Future<Goal?> goalById(GoalByIdRef ref, String id) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getGoalById(id);
}
