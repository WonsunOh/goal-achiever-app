// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motivation_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MotivationMessage _$MotivationMessageFromJson(Map<String, dynamic> json) {
  return _MotivationMessage.fromJson(json);
}

/// @nodoc
mixin _$MotivationMessage {
  String get id => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  MotivationType get type => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool get isCustom => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MotivationMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotivationMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotivationMessageCopyWith<MotivationMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotivationMessageCopyWith<$Res> {
  factory $MotivationMessageCopyWith(
    MotivationMessage value,
    $Res Function(MotivationMessage) then,
  ) = _$MotivationMessageCopyWithImpl<$Res, MotivationMessage>;
  @useResult
  $Res call({
    String id,
    String message,
    MotivationType type,
    String? author,
    String? category,
    bool isCustom,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MotivationMessageCopyWithImpl<$Res, $Val extends MotivationMessage>
    implements $MotivationMessageCopyWith<$Res> {
  _$MotivationMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotivationMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? type = null,
    Object? author = freezed,
    Object? category = freezed,
    Object? isCustom = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MotivationType,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCustom: null == isCustom
                ? _value.isCustom
                : isCustom // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MotivationMessageImplCopyWith<$Res>
    implements $MotivationMessageCopyWith<$Res> {
  factory _$$MotivationMessageImplCopyWith(
    _$MotivationMessageImpl value,
    $Res Function(_$MotivationMessageImpl) then,
  ) = __$$MotivationMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String message,
    MotivationType type,
    String? author,
    String? category,
    bool isCustom,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MotivationMessageImplCopyWithImpl<$Res>
    extends _$MotivationMessageCopyWithImpl<$Res, _$MotivationMessageImpl>
    implements _$$MotivationMessageImplCopyWith<$Res> {
  __$$MotivationMessageImplCopyWithImpl(
    _$MotivationMessageImpl _value,
    $Res Function(_$MotivationMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MotivationMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? type = null,
    Object? author = freezed,
    Object? category = freezed,
    Object? isCustom = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MotivationMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MotivationType,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCustom: null == isCustom
            ? _value.isCustom
            : isCustom // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MotivationMessageImpl implements _MotivationMessage {
  const _$MotivationMessageImpl({
    required this.id,
    required this.message,
    required this.type,
    this.author,
    this.category,
    this.isCustom = false,
    required this.createdAt,
  });

  factory _$MotivationMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotivationMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String message;
  @override
  final MotivationType type;
  @override
  final String? author;
  @override
  final String? category;
  @override
  @JsonKey()
  final bool isCustom;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MotivationMessage(id: $id, message: $message, type: $type, author: $author, category: $category, isCustom: $isCustom, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotivationMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    message,
    type,
    author,
    category,
    isCustom,
    createdAt,
  );

  /// Create a copy of MotivationMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotivationMessageImplCopyWith<_$MotivationMessageImpl> get copyWith =>
      __$$MotivationMessageImplCopyWithImpl<_$MotivationMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MotivationMessageImplToJson(this);
  }
}

abstract class _MotivationMessage implements MotivationMessage {
  const factory _MotivationMessage({
    required final String id,
    required final String message,
    required final MotivationType type,
    final String? author,
    final String? category,
    final bool isCustom,
    required final DateTime createdAt,
  }) = _$MotivationMessageImpl;

  factory _MotivationMessage.fromJson(Map<String, dynamic> json) =
      _$MotivationMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get message;
  @override
  MotivationType get type;
  @override
  String? get author;
  @override
  String? get category;
  @override
  bool get isCustom;
  @override
  DateTime get createdAt;

  /// Create a copy of MotivationMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotivationMessageImplCopyWith<_$MotivationMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
