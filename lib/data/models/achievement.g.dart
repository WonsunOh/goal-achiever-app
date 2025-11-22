// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      achievementDate: DateTime.parse(json['achievementDate'] as String),
      note: json['note'] as String,
      emoji: json['emoji'] as String? ?? '🎉',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goalId': instance.goalId,
      'achievementDate': instance.achievementDate.toIso8601String(),
      'note': instance.note,
      'emoji': instance.emoji,
      'createdAt': instance.createdAt.toIso8601String(),
    };
