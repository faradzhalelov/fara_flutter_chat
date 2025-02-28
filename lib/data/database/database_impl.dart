import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database_impl.g.dart';

class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get username => text()();
  TextColumn get avatarUrl => text().nullable()();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ChatsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get userIds => text()(); // Stored as JSON string
  TextColumn get lastMessageText => text().nullable()();
  TextColumn get lastMessageUserId => text().nullable()();
  TextColumn get lastMessageType => text().nullable()();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MessagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get type => text()();
  TextColumn get fileUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [UsersTable, ChatsTable, MessagesTable])
class AppDatabaseImpl extends _$AppDatabaseImpl implements AppDatabase {
  AppDatabaseImpl() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  
  // User operations
  @override
  Future<void> upsertUser(User user) async {
    await into(usersTable).insertOnConflictUpdate(
      UsersTableCompanion.insert(
        id: user.id,
        email: user.email,
        username: user.username,
        avatarUrl: Value(user.avatarUrl),
        isOnline: Value(user.isOnline),
      ),
    );
  }
  
  @override
  Future<User?> getUserById(String userId) async {
    final result = await (select(usersTable)..where((u) => u.id.equals(userId))).getSingleOrNull();
    if (result == null) return null;
    
    return User(
      id: result.id,
      email: result.email,
      username: result.username,
      avatarUrl: result.avatarUrl,
      isOnline: result.isOnline,
    );
  }
  
  @override
  Future<List<User>> getAllUsers() async {
    final results = await select(usersTable).get();
    
    return results.map((row) => User(
      id: row.id,
      email: row.email,
      username: row.username,
      avatarUrl: row.avatarUrl,
      isOnline: row.isOnline,
    )).toList();
  }
  
  // Chat operations
  @override
  Future<void> upsertChat(Chat chat) async {
    await into(chatsTable).insertOnConflictUpdate(
      ChatsTableCompanion.insert(
        id: chat.id,
        name: Value(chat.name),
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        userIds: jsonEncode(chat.userIds),
        lastMessageText: Value(chat.lastMessageText),
        lastMessageUserId: Value(chat.lastMessageUserId),
        lastMessageType: Value(chat.lastMessageType),
        lastMessageAt: Value(chat.lastMessageAt),
      ),
    );
  }
  
  @override
  Future<Chat?> getChatById(String chatId) async {
    final result = await (select(chatsTable)..where((c) => c.id.equals(chatId))).getSingleOrNull();
    if (result == null) return null;
    
    return Chat(
      id: result.id,
      name: result.name,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
      userIds: _parseUserIds(result.userIds),
      lastMessageText: result.lastMessageText,
      lastMessageUserId: result.lastMessageUserId,
      lastMessageType: result.lastMessageType,
      lastMessageAt: result.lastMessageAt,
    );
  }
  
  @override
  Future<List<Chat>> getAllChats() async {
    final results = await (select(chatsTable)
      ..orderBy([
        (t) => OrderingTerm(
          expression: t.lastMessageAt,
          mode: OrderingMode.desc,
          nulls: NullsOrder.last,
        ),
        (t) => OrderingTerm(
          expression: t.createdAt,
          mode: OrderingMode.desc,
        ),
      ])
    ).get();
    
    return results.map(_mapRowToChat).toList();
  }
  
  @override
  Stream<List<Chat>> watchAllChats() => (select(chatsTable)
      ..orderBy([
        (t) => OrderingTerm(
          expression: t.lastMessageAt,
          mode: OrderingMode.desc,
          nulls: NullsOrder.last,
        ),
        (t) => OrderingTerm(
          expression: t.createdAt,
          mode: OrderingMode.desc,
        ),
      ])
    ).watch().map((rows) => rows.map(_mapRowToChat).toList());
  
  @override
  Future<void> deleteChat(String chatId) async {
    // Delete messages first to maintain referential integrity
    await (delete(messagesTable)..where((m) => m.chatId.equals(chatId))).go();
    // Then delete the chat
    await (delete(chatsTable)..where((c) => c.id.equals(chatId))).go();
  }
  
  // Message operations
  @override
  Future<void> upsertMessage(Message message) async {
    await into(messagesTable).insertOnConflictUpdate(
      MessagesTableCompanion.insert(
        id: message.id,
        chatId: message.chatId,
        userId: Value(message.userId),
        content: Value(message.content),
        type: message.type,
        fileUrl: Value(message.fileUrl),
        createdAt: message.createdAt,
      ),
    );
  }
  
  @override
  Future<List<Message>> getChatMessages(String chatId) async {
    final results = await (select(messagesTable)
      ..where((m) => m.chatId.equals(chatId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)])
    ).get();
    
    return results.map(_mapRowToMessage).toList();
  }
  
  @override
  Stream<List<Message>> watchChatMessages(String chatId) => (select(messagesTable)
      ..where((m) => m.chatId.equals(chatId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)])
    ).watch().map((rows) => rows.map(_mapRowToMessage).toList());
  
  // Helper methods
  Chat _mapRowToChat(ChatsTableData row) => Chat(
      id: row.id,
      name: row.name,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      userIds: _parseUserIds(row.userIds),
      lastMessageText: row.lastMessageText,
      lastMessageUserId: row.lastMessageUserId,
      lastMessageType: row.lastMessageType,
      lastMessageAt: row.lastMessageAt,
    );
  
  Message _mapRowToMessage(MessagesTableData row) => Message(
      id: row.id,
      chatId: row.chatId,
      userId: row.userId,
      content: row.content,
      type: row.type,
      fileUrl: row.fileUrl,
      createdAt: row.createdAt,
    );
  
  List<String> _parseUserIds(String userIdsJson) {
    try {
      final List<dynamic> parsed = jsonDecode(userIdsJson) as List;
      return parsed.cast<String>();
    } catch (e) {
      log('Error parsing userIds JSON: $e');
      return [];
    }
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final userId = supabase.auth.currentUser?.id ?? 'user';
    final file = File(p.join(dbFolder.path, '$userId.sqlite'));
    return NativeDatabase(file);
  });