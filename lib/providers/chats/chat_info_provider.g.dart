// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatInfoHash() => r'f52cdd4bc2b5f90d7c1affac0157c1653b54666e';

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

/// See also [chatInfo].
@ProviderFor(chatInfo)
const chatInfoProvider = ChatInfoFamily();

/// See also [chatInfo].
class ChatInfoFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [chatInfo].
  const ChatInfoFamily();

  /// See also [chatInfo].
  ChatInfoProvider call(
    String chatId,
  ) {
    return ChatInfoProvider(
      chatId,
    );
  }

  @override
  ChatInfoProvider getProviderOverride(
    covariant ChatInfoProvider provider,
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
  String? get name => r'chatInfoProvider';
}

/// See also [chatInfo].
class ChatInfoProvider extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [chatInfo].
  ChatInfoProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatInfo(
            ref as ChatInfoRef,
            chatId,
          ),
          from: chatInfoProvider,
          name: r'chatInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatInfoHash,
          dependencies: ChatInfoFamily._dependencies,
          allTransitiveDependencies: ChatInfoFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatInfoProvider._internal(
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
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(ChatInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatInfoProvider._internal(
        (ref) => create(ref as ChatInfoRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ChatInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatInfoProvider && other.chatId == chatId;
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
mixin ChatInfoRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatInfoProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ChatInfoRef {
  _ChatInfoProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatInfoProvider).chatId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
