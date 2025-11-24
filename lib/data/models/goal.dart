import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String title,
    required String description,
    required GoalCategory category,
    required DateTime startDate,
    required DateTime targetDate,
    @Default(false) bool isCompleted,
    @Default(0.0) double progress,
    @Default('') String motivationQuote,
    @Default(<int>[]) List<int> recurringDays, // 1=월, 2=화, ..., 7=일
    DateTime? reminderTime, // 알림 시간 (시:분만 사용)
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
