import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/enums.dart';

part 'database.g.dart';

// Goals 테이블
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get category => intEnum<GoalCategory>()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get targetDate => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  TextColumn get motivationQuote => text().withDefault(const Constant(''))();
  TextColumn get recurringDays => text().withDefault(const Constant(''))(); // 콤마로 구분된 요일 (1-7)
  DateTimeColumn get reminderTime => dateTime().nullable()(); // 알림 시간
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// DailyTasks 테이블
class DailyTasks extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get scheduledDate => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get reminderTime => dateTime().nullable()();
  IntColumn get priority => intEnum<Priority>().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get completionNote => text().nullable()(); // 완료 시 메모/소감

  @override
  Set<Column> get primaryKey => {id};
}

// Achievements 테이블
class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  DateTimeColumn get achievementDate => dateTime()();
  TextColumn get note => text()();
  TextColumn get emoji => text().withDefault(const Constant('🎉'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// MotivationMessages 테이블
class MotivationMessages extends Table {
  TextColumn get id => text()();
  TextColumn get message => text()();
  IntColumn get type => intEnum<MotivationType>()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Goals, DailyTasks, Achievements, MotivationMessages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // recurringDays 컬럼 추가
          await m.addColumn(goals, goals.recurringDays);
        }
        if (from < 3) {
          // reminderTime 컬럼 추가
          await m.addColumn(goals, goals.reminderTime);
        }
        if (from < 4) {
          // completionNote 컬럼 추가
          await m.addColumn(dailyTasks, dailyTasks.completionNote);
        }
      },
    );
  }

  // Goals CRUD
  Future<List<Goal>> getAllGoals() => select(goals).get();

  Future<Goal?> getGoalById(String id) {
    return (select(goals)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<List<Goal>> watchAllGoals() => select(goals).watch();

  Future<int> insertGoal(GoalsCompanion goal) => into(goals).insert(goal);

  Future<bool> updateGoal(GoalsCompanion goal) => update(goals).replace(goal);

  Future<int> deleteGoal(String id) {
    return (delete(goals)..where((tbl) => tbl.id.equals(id))).go();
  }

  // DailyTasks CRUD
  Future<List<DailyTask>> getAllTasks() => select(dailyTasks).get();

  Future<List<DailyTask>> getTasksByGoalId(String goalId) {
    return (select(dailyTasks)..where((tbl) => tbl.goalId.equals(goalId))).get();
  }

  Future<List<DailyTask>> getTasksByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(dailyTasks)
          ..where((tbl) =>
              tbl.scheduledDate.isBiggerOrEqualValue(startOfDay) &
              tbl.scheduledDate.isSmallerThanValue(endOfDay)))
        .get();
  }

  Stream<List<DailyTask>> watchTasksByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(dailyTasks)
          ..where((tbl) =>
              tbl.scheduledDate.isBiggerOrEqualValue(startOfDay) &
              tbl.scheduledDate.isSmallerThanValue(endOfDay)))
        .watch();
  }

  Future<int> insertTask(DailyTasksCompanion task) => into(dailyTasks).insert(task);

  Future<bool> updateTask(DailyTasksCompanion task) => update(dailyTasks).replace(task);

  Future<int> deleteTask(String id) {
    return (delete(dailyTasks)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// goalId에 해당하는 모든 할일 삭제
  Future<int> deleteTasksByGoalId(String goalId) {
    return (delete(dailyTasks)..where((tbl) => tbl.goalId.equals(goalId))).go();
  }

  // Achievements CRUD
  Future<List<Achievement>> getAllAchievements() => select(achievements).get();

  Future<List<Achievement>> getAchievementsByGoalId(String goalId) {
    return (select(achievements)..where((tbl) => tbl.goalId.equals(goalId))).get();
  }

  Future<int> insertAchievement(AchievementsCompanion achievement) {
    return into(achievements).insert(achievement);
  }

  Future<int> deleteAchievement(String id) {
    return (delete(achievements)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// goalId에 해당하는 모든 성취 삭제
  Future<int> deleteAchievementsByGoalId(String goalId) {
    return (delete(achievements)..where((tbl) => tbl.goalId.equals(goalId))).go();
  }

  // MotivationMessages CRUD
  Future<List<MotivationMessage>> getAllMotivationMessages() {
    return select(motivationMessages).get();
  }

  Future<List<MotivationMessage>> getMessagesByType(MotivationType type) {
    return (select(motivationMessages)..where((tbl) => tbl.type.equalsValue(type)))
        .get();
  }

  Future<int> insertMotivationMessage(MotivationMessagesCompanion message) {
    return into(motivationMessages).insert(message);
  }

  Future<int> deleteMotivationMessage(String id) {
    return (delete(motivationMessages)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 모든 데이터 삭제
  Future<void> deleteAllData() async {
    await delete(dailyTasks).go();
    await delete(achievements).go();
    await delete(goals).go();
    await delete(motivationMessages).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
