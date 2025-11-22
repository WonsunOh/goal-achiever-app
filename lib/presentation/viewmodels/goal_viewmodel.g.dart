// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalByIdHash() => r'374c41ff018b17bfa69c30e7de1a9e22b290a8a1';

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

/// See also [goalById].
@ProviderFor(goalById)
const goalByIdProvider = GoalByIdFamily();

/// See also [goalById].
class GoalByIdFamily extends Family<AsyncValue<Goal?>> {
  /// See also [goalById].
  const GoalByIdFamily();

  /// See also [goalById].
  GoalByIdProvider call(String id) {
    return GoalByIdProvider(id);
  }

  @override
  GoalByIdProvider getProviderOverride(covariant GoalByIdProvider provider) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goalByIdProvider';
}

/// See also [goalById].
class GoalByIdProvider extends AutoDisposeFutureProvider<Goal?> {
  /// See also [goalById].
  GoalByIdProvider(String id)
    : this._internal(
        (ref) => goalById(ref as GoalByIdRef, id),
        from: goalByIdProvider,
        name: r'goalByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$goalByIdHash,
        dependencies: GoalByIdFamily._dependencies,
        allTransitiveDependencies: GoalByIdFamily._allTransitiveDependencies,
        id: id,
      );

  GoalByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(FutureOr<Goal?> Function(GoalByIdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: GoalByIdProvider._internal(
        (ref) => create(ref as GoalByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Goal?> createElement() {
    return _GoalByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoalByIdRef on AutoDisposeFutureProviderRef<Goal?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GoalByIdProviderElement extends AutoDisposeFutureProviderElement<Goal?>
    with GoalByIdRef {
  _GoalByIdProviderElement(super.provider);

  @override
  String get id => (origin as GoalByIdProvider).id;
}

String _$goalViewModelHash() => r'3b68159281a27fd66ea5546af036da0ab1a6c986';

/// See also [GoalViewModel].
@ProviderFor(GoalViewModel)
final goalViewModelProvider =
    AutoDisposeStreamNotifierProvider<GoalViewModel, List<Goal>>.internal(
      GoalViewModel.new,
      name: r'goalViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$goalViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GoalViewModel = AutoDisposeStreamNotifier<List<Goal>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
