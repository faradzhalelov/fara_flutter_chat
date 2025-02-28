// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThemeHash() => r'768cb35682833d3e08c8373ec4816e8289b25782';

/// Provider for the current ThemeData based on the selected theme mode
///
/// Copied from [currentTheme].
@ProviderFor(currentTheme)
final currentThemeProvider = AutoDisposeProvider<ThemeData>.internal(
  currentTheme,
  name: r'currentThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$themeViewModelHash() => r'6a5523636f86f758142d99e34d5ce18e2ed3de00';

/// See also [ThemeViewModel].
@ProviderFor(ThemeViewModel)
final themeViewModelProvider =
    AutoDisposeNotifierProvider<ThemeViewModel, ThemeMode>.internal(
  ThemeViewModel.new,
  name: r'themeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeViewModel = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
