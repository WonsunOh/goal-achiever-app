import 'package:drift/drift.dart';
import '../local/database.dart';
import '../models/goal.dart' as model;

class GoalRepository {
  final AppDatabase _database;

  GoalRepository(this._database);

  Future<List<model.Goal>> getAllGoals() async {
    final goals = await _database.getAllGoals();
    return goals.map(_mapToModel).toList();
  }

  Stream<List<model.Goal>> watchAllGoals() {
    return _database.watchAllGoals().map(
          (goals) => goals.map(_mapToModel).toList(),
        );
  }

  Future<model.Goal?> getGoalById(String id) async {
    final goal = await _database.getGoalById(id);
    return goal != null ? _mapToModel(goal) : null;
  }

  Stream<model.Goal?> watchGoalById(String id) {
    return _database.watchGoalById(id).map(
          (goal) => goal != null ? _mapToModel(goal) : null,
        );
  }

  Future<void> createGoal(model.Goal goal) async {
    await _database.insertGoal(_mapToCompanion(goal));
  }

  Future<void> updateGoal(model.Goal goal) async {
    await _database.updateGoal(_mapToCompanion(goal));
  }

  Future<void> deleteGoal(String id) async {
    await _database.deleteGoal(id);
  }

  Future<void> updateGoalProgress(String id, double progress) async {
    final goal = await getGoalById(id);
    if (goal != null) {
      final updatedGoal = goal.copyWith(
        progress: progress,
        isCompleted: progress >= 1.0,
        completedAt: progress >= 1.0 ? DateTime.now() : null,
      );
      await updateGoal(updatedGoal);
    }
  }

  model.Goal _mapToModel(Goal dbGoal) {
    return model.Goal(
      id: dbGoal.id,
      title: dbGoal.title,
      description: dbGoal.description,
      category: dbGoal.category,
      startDate: dbGoal.startDate,
      targetDate: dbGoal.targetDate,
      isCompleted: dbGoal.isCompleted,
      progress: dbGoal.progress,
      motivationQuote: dbGoal.motivationQuote,
      recurringDays: _parseRecurringDays(dbGoal.recurringDays),
      reminderTime: dbGoal.reminderTime,
      createdAt: dbGoal.createdAt,
      completedAt: dbGoal.completedAt,
    );
  }

  GoalsCompanion _mapToCompanion(model.Goal goal) {
    return GoalsCompanion(
      id: Value(goal.id),
      title: Value(goal.title),
      description: Value(goal.description),
      category: Value(goal.category),
      startDate: Value(goal.startDate),
      targetDate: Value(goal.targetDate),
      isCompleted: Value(goal.isCompleted),
      progress: Value(goal.progress),
      motivationQuote: Value(goal.motivationQuote),
      recurringDays: Value(_serializeRecurringDays(goal.recurringDays)),
      reminderTime: Value(goal.reminderTime),
      createdAt: Value(goal.createdAt),
      completedAt: Value(goal.completedAt),
    );
  }

  /// 콤마로 구분된 문자열을 List<int>로 변환
  List<int> _parseRecurringDays(String days) {
    if (days.isEmpty) return [];
    return days.split(',').map((d) => int.tryParse(d.trim()) ?? 0).where((d) => d > 0).toList();
  }

  /// List<int>를 콤마로 구분된 문자열로 변환
  String _serializeRecurringDays(List<int> days) {
    return days.join(',');
  }
}
