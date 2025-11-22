import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/goal.dart';
import '../../data/models/enums.dart';
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

  Future<void> createGoal({
    required String title,
    required String description,
    required GoalCategory category,
    required DateTime startDate,
    required DateTime targetDate,
    String motivationQuote = '',
  }) async {
    final repository = ref.read(goalRepositoryProvider);
    final goal = Goal(
      id: _uuid.v4(),
      title: title,
      description: description,
      category: category,
      startDate: startDate,
      targetDate: targetDate,
      motivationQuote: motivationQuote,
      createdAt: DateTime.now(),
    );

    await repository.createGoal(goal);
  }

  Future<void> updateGoal(Goal goal) async {
    final repository = ref.read(goalRepositoryProvider);
    await repository.updateGoal(goal);
  }

  Future<void> deleteGoal(String id) async {
    final repository = ref.read(goalRepositoryProvider);
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
