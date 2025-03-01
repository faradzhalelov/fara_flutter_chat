// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatViewModelHash() => r'e0ff3ff9c4f20f0caffe073dbd2ab66a4b2ab54e';

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

abstract class _$ChatViewModel extends BuildlessAutoDisposeAsyncNotifier<void> {
  late final String chatId;

  FutureOr<void> build(
    String chatId,
  );
}

/// ViewModel for the chat screen using the abstract ChatRepository
///
/// Copied from [ChatViewModel].
@ProviderFor(ChatViewModel)
const chatViewModelProvider = ChatViewModelFamily();

/// ViewModel for the chat screen using the abstract ChatRepository
///
/// Copied from [ChatViewModel].
class ChatViewModelFamily extends Family<AsyncValue<void>> {
  /// ViewModel for the chat screen using the abstract ChatRepository
  ///
  /// Copied from [ChatViewModel].
  const ChatViewModelFamily();

  /// ViewModel for the chat screen using the abstract ChatRepository
  ///
  /// Copied from [ChatViewModel].
  ChatViewModelProvider call(
    String chatId,
  ) {
    return ChatViewModelProvider(
      chatId,
    );
  }

  @override
  ChatViewModelProvider getProviderOverride(
    covariant ChatViewModelProvider provider,
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
  String? get name => r'chatViewModelProvider';
}

/// ViewModel for the chat screen using the abstract ChatRepository
///
/// Copied from [ChatViewModel].
class ChatViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatViewModel, void> {
  /// ViewModel for the chat screen using the abstract ChatRepository
  ///
  /// Copied from [ChatViewModel].
  ChatViewModelProvider(
    String chatId,
  ) : this._internal(
          () => ChatViewModel()..chatId = chatId,
          from: chatViewModelProvider,
          name: r'chatViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatViewModelHash,
          dependencies: ChatViewModelFamily._dependencies,
          allTransitiveDependencies:
              ChatViewModelFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatViewModelProvider._internal(
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
  FutureOr<void> runNotifierBuild(
    covariant ChatViewModel notifier,
  ) {
    return notifier.build(
      chatId,
    );
  }

  @override
  Override overrideWith(ChatViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ChatViewModel, void> createElement() {
    return _ChatViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatViewModelProvider && other.chatId == chatId;
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
mixin ChatViewModelRef on AutoDisposeAsyncNotifierProviderRef<void> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatViewModel, void>
    with ChatViewModelRef {
  _ChatViewModelProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatViewModelProvider).chatId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
