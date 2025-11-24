// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return _Goal.fromJson(json);
}

/// @nodoc
mixin _$Goal {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  GoalCategory get category => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get targetDate => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String get motivationQuote => throw _privateConstructorUsedError;
  List<int> get recurringDays =>
      throw _privateConstructorUsedError; // 1=월, 2=화, ..., 7=일
  DateTime? get reminderTime =>
      throw _privateConstructorUsedError; // 알림 시간 (시:분만 사용)
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    GoalCategory category,
    DateTime startDate,
    DateTime targetDate,
    bool isCompleted,
    double progress,
    String motivationQuote,
    List<int> recurringDays,
    DateTime? reminderTime,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? startDate = null,
    Object? targetDate = null,
    Object? isCompleted = null,
    Object? progress = null,
    Object? motivationQuote = null,
    Object? recurringDays = null,
    Object? reminderTime = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as GoalCategory,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            targetDate: null == targetDate
                ? _value.targetDate
                : targetDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            motivationQuote: null == motivationQuote
                ? _value.motivationQuote
                : motivationQuote // ignore: cast_nullable_to_non_nullable
                      as String,
            recurringDays: null == recurringDays
                ? _value.recurringDays
                : recurringDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            reminderTime: freezed == reminderTime
                ? _value.reminderTime
                : reminderTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
    _$GoalImpl value,
    $Res Function(_$GoalImpl) then,
  ) = __$$GoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    GoalCategory category,
    DateTime startDate,
    DateTime targetDate,
    bool isCompleted,
    double progress,
    String motivationQuote,
    List<int> recurringDays,
    DateTime? reminderTime,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
    : super(_value, _then);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? startDate = null,
    Object? targetDate = null,
    Object? isCompleted = null,
    Object? progress = null,
    Object? motivationQuote = null,
    Object? recurringDays = null,
    Object? reminderTime = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$GoalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as GoalCategory,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        targetDate: null == targetDate
            ? _value.targetDate
            : targetDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        motivationQuote: null == motivationQuote
            ? _value.motivationQuote
            : motivationQuote // ignore: cast_nullable_to_non_nullable
                  as String,
        recurringDays: null == recurringDays
            ? _value._recurringDays
            : recurringDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        reminderTime: freezed == reminderTime
            ? _value.reminderTime
            : reminderTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalImpl implements _Goal {
  const _$GoalImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.targetDate,
    this.isCompleted = false,
    this.progress = 0.0,
    this.motivationQuote = '',
    final List<int> recurringDays = const <int>[],
    this.reminderTime,
    required this.createdAt,
    this.completedAt,
  }) : _recurringDays = recurringDays;

  factory _$GoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final GoalCategory category;
  @override
  final DateTime startDate;
  @override
  final DateTime targetDate;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final String motivationQuote;
  final List<int> _recurringDays;
  @override
  @JsonKey()
  List<int> get recurringDays {
    if (_recurringDays is EqualUnmodifiableListView) return _recurringDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recurringDays);
  }

  // 1=월, 2=화, ..., 7=일
  @override
  final DateTime? reminderTime;
  // 알림 시간 (시:분만 사용)
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'Goal(id: $id, title: $title, description: $description, category: $category, startDate: $startDate, targetDate: $targetDate, isCompleted: $isCompleted, progress: $progress, motivationQuote: $motivationQuote, recurringDays: $recurringDays, reminderTime: $reminderTime, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.motivationQuote, motivationQuote) ||
                other.motivationQuote == motivationQuote) &&
            const DeepCollectionEquality().equals(
              other._recurringDays,
              _recurringDays,
            ) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    category,
    startDate,
    targetDate,
    isCompleted,
    progress,
    motivationQuote,
    const DeepCollectionEquality().hash(_recurringDays),
    reminderTime,
    createdAt,
    completedAt,
  );

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalImplToJson(this);
  }
}

abstract class _Goal implements Goal {
  const factory _Goal({
    required final String id,
    required final String title,
    required final String description,
    required final GoalCategory category,
    required final DateTime startDate,
    required final DateTime targetDate,
    final bool isCompleted,
    final double progress,
    final String motivationQuote,
    final List<int> recurringDays,
    final DateTime? reminderTime,
    required final DateTime createdAt,
    final DateTime? completedAt,
  }) = _$GoalImpl;

  factory _Goal.fromJson(Map<String, dynamic> json) = _$GoalImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  GoalCategory get category;
  @override
  DateTime get startDate;
  @override
  DateTime get targetDate;
  @override
  bool get isCompleted;
  @override
  double get progress;
  @override
  String get motivationQuote;
  @override
  List<int> get recurringDays; // 1=월, 2=화, ..., 7=일
  @override
  DateTime? get reminderTime; // 알림 시간 (시:분만 사용)
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
