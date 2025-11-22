import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'motivation_message.freezed.dart';
part 'motivation_message.g.dart';

@freezed
class MotivationMessage with _$MotivationMessage {
  const factory MotivationMessage({
    required String id,
    required String message,
    required MotivationType type,
    String? author,
    String? category,
    @Default(false) bool isCustom,
    required DateTime createdAt,
  }) = _MotivationMessage;

  factory MotivationMessage.fromJson(Map<String, dynamic> json) =>
      _$MotivationMessageFromJson(json);
}
