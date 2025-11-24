// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: $enumDecode(_$GoalCategoryEnumMap, json['category']),
  startDate: DateTime.parse(json['startDate'] as String),
  targetDate: DateTime.parse(json['targetDate'] as String),
  isCompleted: json['isCompleted'] as bool? ?? false,
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
  motivationQuote: json['motivationQuote'] as String? ?? '',
  recurringDays:
      (json['recurringDays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  reminderTime: json['reminderTime'] == null
      ? null
      : DateTime.parse(json['reminderTime'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$GoalCategoryEnumMap[instance.category]!,
      'startDate': instance.startDate.toIso8601String(),
      'targetDate': instance.targetDate.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'progress': instance.progress,
      'motivationQuote': instance.motivationQuote,
      'recurringDays': instance.recurringDays,
      'reminderTime': instance.reminderTime?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$GoalCategoryEnumMap = {
  GoalCategory.health: 'health',
  GoalCategory.exercise: 'exercise',
  GoalCategory.learning: 'learning',
  GoalCategory.finance: 'finance',
  GoalCategory.hobby: 'hobby',
  GoalCategory.career: 'career',
  GoalCategory.relationship: 'relationship',
  GoalCategory.other: 'other',
};
