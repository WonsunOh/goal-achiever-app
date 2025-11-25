import 'package:drift/drift.dart';
import '../local/database.dart';
import '../models/daily_task.dart' as model;

class DailyTaskRepository {
  final AppDatabase _database;

  DailyTaskRepository(this._database);

  Future<List<model.DailyTask>> getAllTasks() async {
    final tasks = await _database.getAllTasks();
    return tasks.map(_mapToModel).toList();
  }

  Future<List<model.DailyTask>> getTasksByGoalId(String goalId) async {
    final tasks = await _database.getTasksByGoalId(goalId);
    return tasks.map(_mapToModel).toList();
  }

  Stream<List<model.DailyTask>> watchTasksByGoalId(String goalId) {
    return _database.watchTasksByGoalId(goalId).map(
          (tasks) => tasks.map(_mapToModel).toList(),
        );
  }

  Future<List<model.DailyTask>> getTasksByDate(DateTime date) async {
    final tasks = await _database.getTasksByDate(date);
    return tasks.map(_mapToModel).toList();
  }

  Stream<List<model.DailyTask>> watchTasksByDate(DateTime date) {
    return _database.watchTasksByDate(date).map(
          (tasks) => tasks.map(_mapToModel).toList(),
        );
  }

  Future<void> createTask(model.DailyTask task) async {
    await _database.insertTask(_mapToCompanion(task));
  }

  Future<void> updateTask(model.DailyTask task) async {
    await _database.updateTask(_mapToCompanion(task));
  }

  Future<void> deleteTask(String id) async {
    await _database.deleteTask(id);
  }

  /// goalId에 해당하는 모든 할일 삭제
  Future<void> deleteTasksByGoalId(String goalId) async {
    await _database.deleteTasksByGoalId(goalId);
  }

  /// goalId에 해당하고, 오늘 이후이며, 미완료된, 특정 요일의 할일 삭제
  Future<int> deleteFutureUncompletedTasksByWeekdays({
    required String goalId,
    required List<int> weekdays,
    required DateTime fromDate,
  }) async {
    return await _database.deleteFutureUncompletedTasksByWeekdays(
      goalId: goalId,
      weekdays: weekdays,
      fromDate: fromDate,
    );
  }

  /// goalId에 해당하고, 특정 날짜 이후의 미완료 할일 삭제
  Future<int> deleteTasksAfterDate({
    required String goalId,
    required DateTime afterDate,
  }) async {
    return await _database.deleteTasksAfterDate(
      goalId: goalId,
      afterDate: afterDate,
    );
  }

  Future<void> toggleTaskCompletion(String id) async {
    final tasks = await _database.getAllTasks();
    final task = tasks.firstWhere((t) => t.id == id);
    final updatedTask = _mapToModel(task).copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    await updateTask(updatedTask);
  }

  model.DailyTask _mapToModel(DailyTask dbTask) {
    return model.DailyTask(
      id: dbTask.id,
      goalId: dbTask.goalId,
      title: dbTask.title,
      description: dbTask.description,
      scheduledDate: dbTask.scheduledDate,
      isCompleted: dbTask.isCompleted,
      completedAt: dbTask.completedAt,
      reminderTime: dbTask.reminderTime,
      priority: dbTask.priority,
      createdAt: dbTask.createdAt,
      completionNote: dbTask.completionNote,
    );
  }

  DailyTasksCompanion _mapToCompanion(model.DailyTask task) {
    return DailyTasksCompanion(
      id: Value(task.id),
      goalId: Value(task.goalId),
      title: Value(task.title),
      description: Value(task.description),
      scheduledDate: Value(task.scheduledDate),
      isCompleted: Value(task.isCompleted),
      completedAt: Value(task.completedAt),
      reminderTime: Value(task.reminderTime),
      priority: Value(task.priority),
      createdAt: Value(task.createdAt),
      completionNote: Value(task.completionNote),
    );
  }
}
