import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Define tables
part 'database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get username => text()();
  TextColumn get avatarUrl => text().nullable()();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Chats extends Table {
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

class Messages extends Table {
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

@DriftDatabase(tables: [Users, Chats, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  
  // User operations
  Future<void> upsertUser(UsersCompanion user) =>
      into(users).insertOnConflictUpdate(user);
      
  Future<void> upsertUsers(List<UsersCompanion> usersList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(users, usersList);
    });
  }
  
  Stream<List<User>> watchAllUsers() => select(users).watch();
  
  Future<User?> getUserById(String userId) =>
      (select(users)..where((u) => u.id.equals(userId))).getSingleOrNull();
  
  // Chat operations
  Future<void> upsertChat(ChatsCompanion chat) =>
      into(chats).insertOnConflictUpdate(chat);
      
  Future<void> upsertChats(List<ChatsCompanion> chatsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(chats, chatsList);
    });
  }
  
  Stream<List<Chat>> watchAllChats() => 
      (select(chats)..orderBy([
        (t) => OrderingTerm(
          expression: t.lastMessageAt,
          mode: OrderingMode.desc,
          nulls: NullsOrder.last
        ),
        (t) => OrderingTerm(
          expression: t.createdAt,
          mode: OrderingMode.desc
        )
      ])).watch();
  
  Future<Chat?> getChatById(String chatId) =>
      (select(chats)..where((c) => c.id.equals(chatId))).getSingleOrNull();
  
  // Message operations
  Future<void> upsertMessage(MessagesCompanion message) =>
      into(messages).insertOnConflictUpdate(message);
      
  Future<void> upsertMessages(List<MessagesCompanion> messagesList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(messages, messagesList);
    });
  }
  
  Stream<List<Message>> watchChatMessages(String chatId) => 
      (select(messages)
        ..where((m) => m.chatId.equals(chatId))
        ..orderBy([(t) => OrderingTerm(
          expression: t.createdAt,
          mode: OrderingMode.asc
        )])
      ).watch();
  
  Future<List<Message>> getChatMessages(String chatId) => 
      (select(messages)
        ..where((m) => m.chatId.equals(chatId))
        ..orderBy([(t) => OrderingTerm(
          expression: t.createdAt,
          mode: OrderingMode.asc
        )])
      ).get();
  
  // Delete operations
  Future<void> deleteChat(String chatId) async {
    // Delete chat messages first
    await (delete(messages)..where((m) => m.chatId.equals(chatId))).go();
    // Then delete the chat
    await (delete(chats)..where((c) => c.id.equals(chatId))).go();
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chat_app.sqlite'));
    return NativeDatabase(file);
  });