// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messagesViewModelHash() => r'b6823d61bd57bc264a744a1485123f28c1494ee0';

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

abstract class _$MessagesViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final String chatId;

  FutureOr<List<Message>> build(
    String chatId,
  );
}

/// See also [MessagesViewModel].
@ProviderFor(MessagesViewModel)
const messagesViewModelProvider = MessagesViewModelFamily();

/// See also [MessagesViewModel].
class MessagesViewModelFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [MessagesViewModel].
  const MessagesViewModelFamily();

  /// See also [MessagesViewModel].
  MessagesViewModelProvider call(
    String chatId,
  ) {
    return MessagesViewModelProvider(
      chatId,
    );
  }

  @override
  MessagesViewModelProvider getProviderOverride(
    covariant MessagesViewModelProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'messagesViewModelProvider';
}

/// See also [MessagesViewModel].
class MessagesViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MessagesViewModel, List<Message>> {
  /// See also [MessagesViewModel].
  MessagesViewModelProvider(
    String chatId,
  ) : this._internal(
          () => MessagesViewModel()..chatId = chatId,
          from: messagesViewModelProvider,
          name: r'messagesViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messagesViewModelHash,
          dependencies: MessagesViewModelFamily._dependencies,
          allTransitiveDependencies:
              MessagesViewModelFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  MessagesViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  FutureOr<List<Message>> runNotifierBuild(
    covariant MessagesViewModel notifier,
  ) {
    return notifier.build(
      chatId,
    );
  }

  @override
  Override overrideWith(MessagesViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessagesViewModelProvider._internal(
        () => create()..chatId = chatId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MessagesViewModel, List<Message>>
      createElement() {
    return _MessagesViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesViewModelProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessagesViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _MessagesViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MessagesViewModel,
        List<Message>> with MessagesViewModelRef {
  _MessagesViewModelProviderElement(super.provider);

  @override
  String get chatId => (origin as MessagesViewModelProvider).chatId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
