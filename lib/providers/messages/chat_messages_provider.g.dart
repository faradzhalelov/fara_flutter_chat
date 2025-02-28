// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatMessagesNotifierHash() =>
    r'702ca8c3e0f88292badf601bb7ec35ee7975ebff';

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

abstract class _$ChatMessagesNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<MessageModel>> {
  late final String chatId;

  Stream<List<MessageModel>> build(
    String chatId,
  );
}

/// See also [ChatMessagesNotifier].
@ProviderFor(ChatMessagesNotifier)
const chatMessagesNotifierProvider = ChatMessagesNotifierFamily();

/// See also [ChatMessagesNotifier].
class ChatMessagesNotifierFamily
    extends Family<AsyncValue<List<MessageModel>>> {
  /// See also [ChatMessagesNotifier].
  const ChatMessagesNotifierFamily();

  /// See also [ChatMessagesNotifier].
  ChatMessagesNotifierProvider call(
    String chatId,
  ) {
    return ChatMessagesNotifierProvider(
      chatId,
    );
  }

  @override
  ChatMessagesNotifierProvider getProviderOverride(
    covariant ChatMessagesNotifierProvider provider,
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
  String? get name => r'chatMessagesNotifierProvider';
}

/// See also [ChatMessagesNotifier].
class ChatMessagesNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<ChatMessagesNotifier,
        List<MessageModel>> {
  /// See also [ChatMessagesNotifier].
  ChatMessagesNotifierProvider(
    String chatId,
  ) : this._internal(
          () => ChatMessagesNotifier()..chatId = chatId,
          from: chatMessagesNotifierProvider,
          name: r'chatMessagesNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesNotifierHash,
          dependencies: ChatMessagesNotifierFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesNotifierFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatMessagesNotifierProvider._internal(
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
  Stream<List<MessageModel>> runNotifierBuild(
    covariant ChatMessagesNotifier notifier,
  ) {
    return notifier.build(
      chatId,
    );
  }

  @override
  Override overrideWith(ChatMessagesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesNotifierProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<ChatMessagesNotifier,
      List<MessageModel>> createElement() {
    return _ChatMessagesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesNotifierProvider && other.chatId == chatId;
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
mixin ChatMessagesNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<MessageModel>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatMessagesNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ChatMessagesNotifier,
        List<MessageModel>> with ChatMessagesNotifierRef {
  _ChatMessagesNotifierProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatMessagesNotifierProvider).chatId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
