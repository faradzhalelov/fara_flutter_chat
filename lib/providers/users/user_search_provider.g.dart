// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userSearchNotifierHash() =>
    r'0977f8487f3ea911e9decd40e37d2dcffc0a808b';

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

abstract class _$UserSearchNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<UserModel>> {
  late final String query;

  FutureOr<List<UserModel>> build(
    String query,
  );
}

/// See also [UserSearchNotifier].
@ProviderFor(UserSearchNotifier)
const userSearchNotifierProvider = UserSearchNotifierFamily();

/// See also [UserSearchNotifier].
class UserSearchNotifierFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [UserSearchNotifier].
  const UserSearchNotifierFamily();

  /// See also [UserSearchNotifier].
  UserSearchNotifierProvider call(
    String query,
  ) {
    return UserSearchNotifierProvider(
      query,
    );
  }

  @override
  UserSearchNotifierProvider getProviderOverride(
    covariant UserSearchNotifierProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userSearchNotifierProvider';
}

/// See also [UserSearchNotifier].
class UserSearchNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserSearchNotifier, List<UserModel>> {
  /// See also [UserSearchNotifier].
  UserSearchNotifierProvider(
    String query,
  ) : this._internal(
          () => UserSearchNotifier()..query = query,
          from: userSearchNotifierProvider,
          name: r'userSearchNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userSearchNotifierHash,
          dependencies: UserSearchNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserSearchNotifierFamily._allTransitiveDependencies,
          query: query,
        );

  UserSearchNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<List<UserModel>> runNotifierBuild(
    covariant UserSearchNotifier notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(UserSearchNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserSearchNotifierProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserSearchNotifier, List<UserModel>>
      createElement() {
    return _UserSearchNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSearchNotifierProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserSearchNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<UserModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _UserSearchNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserSearchNotifier,
        List<UserModel>> with UserSearchNotifierRef {
  _UserSearchNotifierProviderElement(super.provider);

  @override
  String get query => (origin as UserSearchNotifierProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
