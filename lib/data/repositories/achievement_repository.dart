import 'package:drift/drift.dart';
import '../local/database.dart';
import '../models/achievement.dart' as model;

class AchievementRepository {
  final AppDatabase _database;

  AchievementRepository(this._database);

  Future<List<model.Achievement>> getAllAchievements() async {
    final achievements = await _database.getAllAchievements();
    return achievements.map(_mapToModel).toList();
  }

  Future<List<model.Achievement>> getAchievementsByGoalId(String goalId) async {
    final achievements = await _database.getAchievementsByGoalId(goalId);
    return achievements.map(_mapToModel).toList();
  }

  Future<void> createAchievement(model.Achievement achievement) async {
    await _database.insertAchievement(_mapToCompanion(achievement));
  }

  Future<void> deleteAchievement(String id) async {
    await _database.deleteAchievement(id);
  }

  /// goalId에 해당하는 모든 성취 삭제
  Future<void> deleteAchievementsByGoalId(String goalId) async {
    await _database.deleteAchievementsByGoalId(goalId);
  }

  model.Achievement _mapToModel(Achievement dbAchievement) {
    return model.Achievement(
      id: dbAchievement.id,
      goalId: dbAchievement.goalId,
      achievementDate: dbAchievement.achievementDate,
      note: dbAchievement.note,
      emoji: dbAchievement.emoji,
      createdAt: dbAchievement.createdAt,
    );
  }

  AchievementsCompanion _mapToCompanion(model.Achievement achievement) {
    return AchievementsCompanion(
      id: Value(achievement.id),
      goalId: Value(achievement.goalId),
      achievementDate: Value(achievement.achievementDate),
      note: Value(achievement.note),
      emoji: Value(achievement.emoji),
      createdAt: Value(achievement.createdAt),
    );
  }
}
