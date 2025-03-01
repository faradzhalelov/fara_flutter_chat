// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appRouterHash() => r'b55e54e78cc374e42a621a152d7ac7ea128251f1';

/// Router configuration for the app using GoRouter
///
/// Copied from [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = AutoDisposeProvider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRouterRef = AutoDisposeProviderRef<GoRouter>;
String _$routerKeyHash() => r'a24112ff0508aed2ead4a42e016de8a0071a1856';

/// Provider for router key to force rebuild when needed
///
/// Copied from [routerKey].
@ProviderFor(routerKey)
final routerKeyProvider =
    AutoDisposeProvider<GlobalKey<NavigatorState>>.internal(
  routerKey,
  name: r'routerKeyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterKeyRef = AutoDisposeProviderRef<GlobalKey<NavigatorState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
