// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_task_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksByGoalIdHash() => r'f7fcc60d7f4355a254211e53cf40ec10eebc47af';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [tasksByGoalId].
@ProviderFor(tasksByGoalId)
const tasksByGoalIdProvider = TasksByGoalIdFamily();

/// See also [tasksByGoalId].
class TasksByGoalIdFamily extends Family<AsyncValue<List<DailyTask>>> {
  /// See also [tasksByGoalId].
  const TasksByGoalIdFamily();

  /// See also [tasksByGoalId].
  TasksByGoalIdProvider call(String goalId) {
    return TasksByGoalIdProvider(goalId);
  }

  @override
  TasksByGoalIdProvider getProviderOverride(
    covariant TasksByGoalIdProvider provider,
  ) {
    return call(provider.goalId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksByGoalIdProvider';
}

/// See also [tasksByGoalId].
class TasksByGoalIdProvider extends AutoDisposeStreamProvider<List<DailyTask>> {
  /// See also [tasksByGoalId].
  TasksByGoalIdProvider(String goalId)
    : this._internal(
        (ref) => tasksByGoalId(ref as TasksByGoalIdRef, goalId),
        from: tasksByGoalIdProvider,
        name: r'tasksByGoalIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tasksByGoalIdHash,
        dependencies: TasksByGoalIdFamily._dependencies,
        allTransitiveDependencies:
            TasksByGoalIdFamily._allTransitiveDependencies,
        goalId: goalId,
      );

  TasksByGoalIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.goalId,
  }) : super.internal();

  final String goalId;

  @override
  Override overrideWith(
    Stream<List<DailyTask>> Function(TasksByGoalIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksByGoalIdProvider._internal(
        (ref) => create(ref as TasksByGoalIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        goalId: goalId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DailyTask>> createElement() {
    return _TasksByGoalIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByGoalIdProvider && other.goalId == goalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, goalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksByGoalIdRef on AutoDisposeStreamProviderRef<List<DailyTask>> {
  /// The parameter `goalId` of this provider.
  String get goalId;
}

class _TasksByGoalIdProviderElement
    extends AutoDisposeStreamProviderElement<List<DailyTask>>
    with TasksByGoalIdRef {
  _TasksByGoalIdProviderElement(super.provider);

  @override
  String get goalId => (origin as TasksByGoalIdProvider).goalId;
}

String _$todayTasksHash() => r'903aad9c2ae814432f79f3c6271a3d394b286b9b';

/// See also [todayTasks].
@ProviderFor(todayTasks)
final todayTasksProvider = AutoDisposeStreamProvider<List<DailyTask>>.internal(
  todayTasks,
  name: r'todayTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTasksRef = AutoDisposeStreamProviderRef<List<DailyTask>>;
String _$taskStatisticsHash() => r'130fb09891c3127db96670a0eb86337019c6de6f';

/// See also [taskStatistics].
@ProviderFor(taskStatistics)
final taskStatisticsProvider =
    AutoDisposeFutureProvider<TaskStatistics>.internal(
      taskStatistics,
      name: r'taskStatisticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskStatisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskStatisticsRef = AutoDisposeFutureProviderRef<TaskStatistics>;
String _$dailyTaskViewModelHash() =>
    r'f6fcd60b64a564bbd549d6f21e1b13fdf3f0afe8';

abstract class _$DailyTaskViewModel
    extends BuildlessAutoDisposeStreamNotifier<List<DailyTask>> {
  late final DateTime date;

  Stream<List<DailyTask>> build(DateTime date);
}

/// See also [DailyTaskViewModel].
@ProviderFor(DailyTaskViewModel)
const dailyTaskViewModelProvider = DailyTaskViewModelFamily();

/// See also [DailyTaskViewModel].
class DailyTaskViewModelFamily extends Family<AsyncValue<List<DailyTask>>> {
  /// See also [DailyTaskViewModel].
  const DailyTaskViewModelFamily();

  /// See also [DailyTaskViewModel].
  DailyTaskViewModelProvider call(DateTime date) {
    return DailyTaskViewModelProvider(date);
  }

  @override
  DailyTaskViewModelProvider getProviderOverride(
    covariant DailyTaskViewModelProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyTaskViewModelProvider';
}

/// See also [DailyTaskViewModel].
class DailyTaskViewModelProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          DailyTaskViewModel,
          List<DailyTask>
        > {
  /// See also [DailyTaskViewModel].
  DailyTaskViewModelProvider(DateTime date)
    : this._internal(
        () => DailyTaskViewModel()..date = date,
        from: dailyTaskViewModelProvider,
        name: r'dailyTaskViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dailyTaskViewModelHash,
        dependencies: DailyTaskViewModelFamily._dependencies,
        allTransitiveDependencies:
            DailyTaskViewModelFamily._allTransitiveDependencies,
        date: date,
      );

  DailyTaskViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Stream<List<DailyTask>> runNotifierBuild(
    covariant DailyTaskViewModel notifier,
  ) {
    return notifier.build(date);
  }

  @override
  Override overrideWith(DailyTaskViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: DailyTaskViewModelProvider._internal(
        () => create()..date = date,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<DailyTaskViewModel, List<DailyTask>>
  createElement() {
    return _DailyTaskViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyTaskViewModelProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyTaskViewModelRef
    on AutoDisposeStreamNotifierProviderRef<List<DailyTask>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DailyTaskViewModelProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          DailyTaskViewModel,
          List<DailyTask>
        >
    with DailyTaskViewModelRef {
  _DailyTaskViewModelProviderElement(super.provider);

  @override
  DateTime get date => (origin as DailyTaskViewModelProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
