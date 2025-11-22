import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/database.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/daily_task_repository.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../data/repositories/motivation_message_repository.dart';
import '../../services/notification_service.dart';
import '../../services/badge_service.dart';
import '../../services/motivation_service.dart';

part 'database_provider.g.dart';

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}

@riverpod
BadgeService badgeService(BadgeServiceRef ref) {
  final service = BadgeService();
  service.initialize();
  return service;
}

@riverpod
MotivationService motivationService(MotivationServiceRef ref) {
  return MotivationService();
}

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
}

@riverpod
GoalRepository goalRepository(GoalRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return GoalRepository(database);
}

@riverpod
DailyTaskRepository dailyTaskRepository(DailyTaskRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return DailyTaskRepository(database);
}

@riverpod
AchievementRepository achievementRepository(AchievementRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return AchievementRepository(database);
}

@riverpod
MotivationMessageRepository motivationMessageRepository(
    MotivationMessageRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return MotivationMessageRepository(database);
}
