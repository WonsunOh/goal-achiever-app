// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalByIdHash() => r'0e59f4d7ddf85d3126a03bcca6e72de871f4c45f';

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
class GoalByIdProvider extends AutoDisposeStreamProvider<Goal?> {
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
  Override overrideWith(Stream<Goal?> Function(GoalByIdRef provider) create) {
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
  AutoDisposeStreamProviderElement<Goal?> createElement() {
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
mixin GoalByIdRef on AutoDisposeStreamProviderRef<Goal?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GoalByIdProviderElement extends AutoDisposeStreamProviderElement<Goal?>
    with GoalByIdRef {
  _GoalByIdProviderElement(super.provider);

  @override
  String get id => (origin as GoalByIdProvider).id;
}

String _$goalViewModelHash() => r'047f2f371506290ff6453868020dab354c9779f4';

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
