// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motivation_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MotivationMessageImpl _$$MotivationMessageImplFromJson(
  Map<String, dynamic> json,
) => _$MotivationMessageImpl(
  id: json['id'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$MotivationTypeEnumMap, json['type']),
  author: json['author'] as String?,
  category: json['category'] as String?,
  isCustom: json['isCustom'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$MotivationMessageImplToJson(
  _$MotivationMessageImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'message': instance.message,
  'type': _$MotivationTypeEnumMap[instance.type]!,
  'author': instance.author,
  'category': instance.category,
  'isCustom': instance.isCustom,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$MotivationTypeEnumMap = {
  MotivationType.encouragement: 'encouragement',
  MotivationType.celebration: 'celebration',
  MotivationType.reminder: 'reminder',
};
