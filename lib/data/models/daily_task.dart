import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'daily_task.freezed.dart';
part 'daily_task.g.dart';

@freezed
class DailyTask with _$DailyTask {
  const factory DailyTask({
    required String id,
    required String goalId,
    required String title,
    required String description,
    required DateTime scheduledDate,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    DateTime? reminderTime,
    @Default(Priority.medium) Priority priority,
    required DateTime createdAt,
    String? completionNote, // 완료 시 메모/소감
  }) = _DailyTask;

  factory DailyTask.fromJson(Map<String, dynamic> json) =>
      _$DailyTaskFromJson(json);
}
