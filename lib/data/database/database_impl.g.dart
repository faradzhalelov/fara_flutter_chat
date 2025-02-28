// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_impl.dart';

// ignore_for_file: type=lint
class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isOnlineMeta =
      const VerificationMeta('isOnline');
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
      'is_online', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_online" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, email, username, avatarUrl, isOnline];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(Insertable<UsersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('is_online')) {
      context.handle(_isOnlineMeta,
          isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      isOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_online'])!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final bool isOnline;
  const UsersTableData(
      {required this.id,
      required this.email,
      required this.username,
      this.avatarUrl,
      required this.isOnline});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['is_online'] = Variable<bool>(isOnline);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      email: Value(email),
      username: Value(username),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      isOnline: Value(isOnline),
    );
  }

  factory UsersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      username: serializer.fromJson<String>(json['username']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'username': serializer.toJson<String>(username),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'isOnline': serializer.toJson<bool>(isOnline),
    };
  }

  UsersTableData copyWith(
          {String? id,
          String? email,
          String? username,
          Value<String?> avatarUrl = const Value.absent(),
          bool? isOnline}) =>
      UsersTableData(
        id: id ?? this.id,
        email: email ?? this.email,
        username: username ?? this.username,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        isOnline: isOnline ?? this.isOnline,
      );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      username: data.username.present ? data.username.value : this.username,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isOnline: $isOnline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, username, avatarUrl, isOnline);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.email == this.email &&
          other.username == this.username &&
          other.avatarUrl == this.avatarUrl &&
          other.isOnline == this.isOnline);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> username;
  final Value<String?> avatarUrl;
  final Value<bool> isOnline;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String email,
    required String username,
    this.avatarUrl = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email),
        username = Value(username);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? username,
    Expression<String>? avatarUrl,
    Expression<bool>? isOnline,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (isOnline != null) 'is_online': isOnline,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? email,
      Value<String>? username,
      Value<String?>? avatarUrl,
      Value<bool>? isOnline,
      Value<int>? rowid}) {
    return UsersTableCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isOnline: $isOnline, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatsTableTable extends ChatsTable
    with TableInfo<$ChatsTableTable, ChatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _userIdsMeta =
      const VerificationMeta('userIds');
  @override
  late final GeneratedColumn<String> userIds = GeneratedColumn<String>(
      'user_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastMessageTextMeta =
      const VerificationMeta('lastMessageText');
  @override
  late final GeneratedColumn<String> lastMessageText = GeneratedColumn<String>(
      'last_message_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageUserIdMeta =
      const VerificationMeta('lastMessageUserId');
  @override
  late final GeneratedColumn<String> lastMessageUserId =
      GeneratedColumn<String>('last_message_user_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageTypeMeta =
      const VerificationMeta('lastMessageType');
  @override
  late final GeneratedColumn<String> lastMessageType = GeneratedColumn<String>(
      'last_message_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>('last_message_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        createdAt,
        updatedAt,
        userIds,
        lastMessageText,
        lastMessageUserId,
        lastMessageType,
        lastMessageAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChatsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('user_ids')) {
      context.handle(_userIdsMeta,
          userIds.isAcceptableOrUnknown(data['user_ids']!, _userIdsMeta));
    } else if (isInserting) {
      context.missing(_userIdsMeta);
    }
    if (data.containsKey('last_message_text')) {
      context.handle(
          _lastMessageTextMeta,
          lastMessageText.isAcceptableOrUnknown(
              data['last_message_text']!, _lastMessageTextMeta));
    }
    if (data.containsKey('last_message_user_id')) {
      context.handle(
          _lastMessageUserIdMeta,
          lastMessageUserId.isAcceptableOrUnknown(
              data['last_message_user_id']!, _lastMessageUserIdMeta));
    }
    if (data.containsKey('last_message_type')) {
      context.handle(
          _lastMessageTypeMeta,
          lastMessageType.isAcceptableOrUnknown(
              data['last_message_type']!, _lastMessageTypeMeta));
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
          _lastMessageAtMeta,
          lastMessageAt.isAcceptableOrUnknown(
              data['last_message_at']!, _lastMessageAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      userIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_ids'])!,
      lastMessageText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_message_text']),
      lastMessageUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_message_user_id']),
      lastMessageType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_message_type']),
      lastMessageAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_message_at']),
    );
  }

  @override
  $ChatsTableTable createAlias(String alias) {
    return $ChatsTableTable(attachedDatabase, alias);
  }
}

class ChatsTableData extends DataClass implements Insertable<ChatsTableData> {
  final String id;
  final String? name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userIds;
  final String? lastMessageText;
  final String? lastMessageUserId;
  final String? lastMessageType;
  final DateTime? lastMessageAt;
  const ChatsTableData(
      {required this.id,
      this.name,
      required this.createdAt,
      required this.updatedAt,
      required this.userIds,
      this.lastMessageText,
      this.lastMessageUserId,
      this.lastMessageType,
      this.lastMessageAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_ids'] = Variable<String>(userIds);
    if (!nullToAbsent || lastMessageText != null) {
      map['last_message_text'] = Variable<String>(lastMessageText);
    }
    if (!nullToAbsent || lastMessageUserId != null) {
      map['last_message_user_id'] = Variable<String>(lastMessageUserId);
    }
    if (!nullToAbsent || lastMessageType != null) {
      map['last_message_type'] = Variable<String>(lastMessageType);
    }
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    return map;
  }

  ChatsTableCompanion toCompanion(bool nullToAbsent) {
    return ChatsTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userIds: Value(userIds),
      lastMessageText: lastMessageText == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageText),
      lastMessageUserId: lastMessageUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageUserId),
      lastMessageType: lastMessageType == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageType),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
    );
  }

  factory ChatsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userIds: serializer.fromJson<String>(json['userIds']),
      lastMessageText: serializer.fromJson<String?>(json['lastMessageText']),
      lastMessageUserId:
          serializer.fromJson<String?>(json['lastMessageUserId']),
      lastMessageType: serializer.fromJson<String?>(json['lastMessageType']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userIds': serializer.toJson<String>(userIds),
      'lastMessageText': serializer.toJson<String?>(lastMessageText),
      'lastMessageUserId': serializer.toJson<String?>(lastMessageUserId),
      'lastMessageType': serializer.toJson<String?>(lastMessageType),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
    };
  }

  ChatsTableData copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? userIds,
          Value<String?> lastMessageText = const Value.absent(),
          Value<String?> lastMessageUserId = const Value.absent(),
          Value<String?> lastMessageType = const Value.absent(),
          Value<DateTime?> lastMessageAt = const Value.absent()}) =>
      ChatsTableData(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userIds: userIds ?? this.userIds,
        lastMessageText: lastMessageText.present
            ? lastMessageText.value
            : this.lastMessageText,
        lastMessageUserId: lastMessageUserId.present
            ? lastMessageUserId.value
            : this.lastMessageUserId,
        lastMessageType: lastMessageType.present
            ? lastMessageType.value
            : this.lastMessageType,
        lastMessageAt:
            lastMessageAt.present ? lastMessageAt.value : this.lastMessageAt,
      );
  ChatsTableData copyWithCompanion(ChatsTableCompanion data) {
    return ChatsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userIds: data.userIds.present ? data.userIds.value : this.userIds,
      lastMessageText: data.lastMessageText.present
          ? data.lastMessageText.value
          : this.lastMessageText,
      lastMessageUserId: data.lastMessageUserId.present
          ? data.lastMessageUserId.value
          : this.lastMessageUserId,
      lastMessageType: data.lastMessageType.present
          ? data.lastMessageType.value
          : this.lastMessageType,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userIds: $userIds, ')
          ..write('lastMessageText: $lastMessageText, ')
          ..write('lastMessageUserId: $lastMessageUserId, ')
          ..write('lastMessageType: $lastMessageType, ')
          ..write('lastMessageAt: $lastMessageAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt, userIds,
      lastMessageText, lastMessageUserId, lastMessageType, lastMessageAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userIds == this.userIds &&
          other.lastMessageText == this.lastMessageText &&
          other.lastMessageUserId == this.lastMessageUserId &&
          other.lastMessageType == this.lastMessageType &&
          other.lastMessageAt == this.lastMessageAt);
}

class ChatsTableCompanion extends UpdateCompanion<ChatsTableData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userIds;
  final Value<String?> lastMessageText;
  final Value<String?> lastMessageUserId;
  final Value<String?> lastMessageType;
  final Value<DateTime?> lastMessageAt;
  final Value<int> rowid;
  const ChatsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userIds = const Value.absent(),
    this.lastMessageText = const Value.absent(),
    this.lastMessageUserId = const Value.absent(),
    this.lastMessageType = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatsTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userIds,
    this.lastMessageText = const Value.absent(),
    this.lastMessageUserId = const Value.absent(),
    this.lastMessageType = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        userIds = Value(userIds);
  static Insertable<ChatsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userIds,
    Expression<String>? lastMessageText,
    Expression<String>? lastMessageUserId,
    Expression<String>? lastMessageType,
    Expression<DateTime>? lastMessageAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userIds != null) 'user_ids': userIds,
      if (lastMessageText != null) 'last_message_text': lastMessageText,
      if (lastMessageUserId != null) 'last_message_user_id': lastMessageUserId,
      if (lastMessageType != null) 'last_message_type': lastMessageType,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatsTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? userIds,
      Value<String?>? lastMessageText,
      Value<String?>? lastMessageUserId,
      Value<String?>? lastMessageType,
      Value<DateTime?>? lastMessageAt,
      Value<int>? rowid}) {
    return ChatsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userIds: userIds ?? this.userIds,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageUserId: lastMessageUserId ?? this.lastMessageUserId,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (userIds.present) {
      map['user_ids'] = Variable<String>(userIds.value);
    }
    if (lastMessageText.present) {
      map['last_message_text'] = Variable<String>(lastMessageText.value);
    }
    if (lastMessageUserId.present) {
      map['last_message_user_id'] = Variable<String>(lastMessageUserId.value);
    }
    if (lastMessageType.present) {
      map['last_message_type'] = Variable<String>(lastMessageType.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userIds: $userIds, ')
          ..write('lastMessageText: $lastMessageText, ')
          ..write('lastMessageUserId: $lastMessageUserId, ')
          ..write('lastMessageType: $lastMessageType, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTableTable extends MessagesTable
    with TableInfo<$MessagesTableTable, MessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileUrlMeta =
      const VerificationMeta('fileUrl');
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
      'file_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, chatId, userId, content, type, fileUrl, createdAt, isRead];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages_table';
  @override
  VerificationContext validateIntegrity(Insertable<MessagesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('file_url')) {
      context.handle(_fileUrlMeta,
          fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessagesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      fileUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
    );
  }

  @override
  $MessagesTableTable createAlias(String alias) {
    return $MessagesTableTable(attachedDatabase, alias);
  }
}

class MessagesTableData extends DataClass
    implements Insertable<MessagesTableData> {
  final String id;
  final String chatId;
  final String? userId;
  final String? content;
  final String type;
  final String? fileUrl;
  final DateTime createdAt;
  final bool isRead;
  const MessagesTableData(
      {required this.id,
      required this.chatId,
      this.userId,
      this.content,
      required this.type,
      this.fileUrl,
      required this.createdAt,
      required this.isRead});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chat_id'] = Variable<String>(chatId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  MessagesTableCompanion toCompanion(bool nullToAbsent) {
    return MessagesTableCompanion(
      id: Value(id),
      chatId: Value(chatId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      type: Value(type),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      createdAt: Value(createdAt),
      isRead: Value(isRead),
    );
  }

  factory MessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      chatId: serializer.fromJson<String>(json['chatId']),
      userId: serializer.fromJson<String?>(json['userId']),
      content: serializer.fromJson<String?>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chatId': serializer.toJson<String>(chatId),
      'userId': serializer.toJson<String?>(userId),
      'content': serializer.toJson<String?>(content),
      'type': serializer.toJson<String>(type),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  MessagesTableData copyWith(
          {String? id,
          String? chatId,
          Value<String?> userId = const Value.absent(),
          Value<String?> content = const Value.absent(),
          String? type,
          Value<String?> fileUrl = const Value.absent(),
          DateTime? createdAt,
          bool? isRead}) =>
      MessagesTableData(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        userId: userId.present ? userId.value : this.userId,
        content: content.present ? content.value : this.content,
        type: type ?? this.type,
        fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
        createdAt: createdAt ?? this.createdAt,
        isRead: isRead ?? this.isRead,
      );
  MessagesTableData copyWithCompanion(MessagesTableCompanion data) {
    return MessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      userId: data.userId.present ? data.userId.value : this.userId,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessagesTableData(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('userId: $userId, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, chatId, userId, content, type, fileUrl, createdAt, isRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessagesTableData &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.userId == this.userId &&
          other.content == this.content &&
          other.type == this.type &&
          other.fileUrl == this.fileUrl &&
          other.createdAt == this.createdAt &&
          other.isRead == this.isRead);
}

class MessagesTableCompanion extends UpdateCompanion<MessagesTableData> {
  final Value<String> id;
  final Value<String> chatId;
  final Value<String?> userId;
  final Value<String?> content;
  final Value<String> type;
  final Value<String?> fileUrl;
  final Value<DateTime> createdAt;
  final Value<bool> isRead;
  final Value<int> rowid;
  const MessagesTableCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.userId = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesTableCompanion.insert({
    required String id,
    required String chatId,
    this.userId = const Value.absent(),
    this.content = const Value.absent(),
    required String type,
    this.fileUrl = const Value.absent(),
    required DateTime createdAt,
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chatId = Value(chatId),
        type = Value(type),
        createdAt = Value(createdAt);
  static Insertable<MessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? chatId,
    Expression<String>? userId,
    Expression<String>? content,
    Expression<String>? type,
    Expression<String>? fileUrl,
    Expression<DateTime>? createdAt,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (userId != null) 'user_id': userId,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (fileUrl != null) 'file_url': fileUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? chatId,
      Value<String?>? userId,
      Value<String?>? content,
      Value<String>? type,
      Value<String?>? fileUrl,
      Value<DateTime>? createdAt,
      Value<bool>? isRead,
      Value<int>? rowid}) {
    return MessagesTableCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('userId: $userId, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabaseImpl extends GeneratedDatabase {
  _$AppDatabaseImpl(QueryExecutor e) : super(e);
  $AppDatabaseImplManager get managers => $AppDatabaseImplManager(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $ChatsTableTable chatsTable = $ChatsTableTable(this);
  late final $MessagesTableTable messagesTable = $MessagesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [usersTable, chatsTable, messagesTable];
}

typedef $$UsersTableTableCreateCompanionBuilder = UsersTableCompanion Function({
  required String id,
  required String email,
  required String username,
  Value<String?> avatarUrl,
  Value<bool> isOnline,
  Value<int> rowid,
});
typedef $$UsersTableTableUpdateCompanionBuilder = UsersTableCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> username,
  Value<String?> avatarUrl,
  Value<bool> isOnline,
  Value<int> rowid,
});

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabaseImpl, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnFilters(column));
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabaseImpl, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabaseImpl, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);
}

class $$UsersTableTableTableManager extends RootTableManager<
    _$AppDatabaseImpl,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (
      UsersTableData,
      BaseReferences<_$AppDatabaseImpl, $UsersTableTable, UsersTableData>
    ),
    UsersTableData,
    PrefetchHooks Function()> {
  $$UsersTableTableTableManager(_$AppDatabaseImpl db, $UsersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<bool> isOnline = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion(
            id: id,
            email: email,
            username: username,
            avatarUrl: avatarUrl,
            isOnline: isOnline,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String email,
            required String username,
            Value<String?> avatarUrl = const Value.absent(),
            Value<bool> isOnline = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion.insert(
            id: id,
            email: email,
            username: username,
            avatarUrl: avatarUrl,
            isOnline: isOnline,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabaseImpl,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (
      UsersTableData,
      BaseReferences<_$AppDatabaseImpl, $UsersTableTable, UsersTableData>
    ),
    UsersTableData,
    PrefetchHooks Function()>;
typedef $$ChatsTableTableCreateCompanionBuilder = ChatsTableCompanion Function({
  required String id,
  Value<String?> name,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String userIds,
  Value<String?> lastMessageText,
  Value<String?> lastMessageUserId,
  Value<String?> lastMessageType,
  Value<DateTime?> lastMessageAt,
  Value<int> rowid,
});
typedef $$ChatsTableTableUpdateCompanionBuilder = ChatsTableCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> userIds,
  Value<String?> lastMessageText,
  Value<String?> lastMessageUserId,
  Value<String?> lastMessageType,
  Value<DateTime?> lastMessageAt,
  Value<int> rowid,
});

class $$ChatsTableTableFilterComposer
    extends Composer<_$AppDatabaseImpl, $ChatsTableTable> {
  $$ChatsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userIds => $composableBuilder(
      column: $table.userIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMessageText => $composableBuilder(
      column: $table.lastMessageText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMessageUserId => $composableBuilder(
      column: $table.lastMessageUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMessageType => $composableBuilder(
      column: $table.lastMessageType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => ColumnFilters(column));
}

class $$ChatsTableTableOrderingComposer
    extends Composer<_$AppDatabaseImpl, $ChatsTableTable> {
  $$ChatsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userIds => $composableBuilder(
      column: $table.userIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMessageText => $composableBuilder(
      column: $table.lastMessageText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMessageUserId => $composableBuilder(
      column: $table.lastMessageUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMessageType => $composableBuilder(
      column: $table.lastMessageType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ChatsTableTableAnnotationComposer
    extends Composer<_$AppDatabaseImpl, $ChatsTableTable> {
  $$ChatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get userIds =>
      $composableBuilder(column: $table.userIds, builder: (column) => column);

  GeneratedColumn<String> get lastMessageText => $composableBuilder(
      column: $table.lastMessageText, builder: (column) => column);

  GeneratedColumn<String> get lastMessageUserId => $composableBuilder(
      column: $table.lastMessageUserId, builder: (column) => column);

  GeneratedColumn<String> get lastMessageType => $composableBuilder(
      column: $table.lastMessageType, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => column);
}

class $$ChatsTableTableTableManager extends RootTableManager<
    _$AppDatabaseImpl,
    $ChatsTableTable,
    ChatsTableData,
    $$ChatsTableTableFilterComposer,
    $$ChatsTableTableOrderingComposer,
    $$ChatsTableTableAnnotationComposer,
    $$ChatsTableTableCreateCompanionBuilder,
    $$ChatsTableTableUpdateCompanionBuilder,
    (
      ChatsTableData,
      BaseReferences<_$AppDatabaseImpl, $ChatsTableTable, ChatsTableData>
    ),
    ChatsTableData,
    PrefetchHooks Function()> {
  $$ChatsTableTableTableManager(_$AppDatabaseImpl db, $ChatsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> userIds = const Value.absent(),
            Value<String?> lastMessageText = const Value.absent(),
            Value<String?> lastMessageUserId = const Value.absent(),
            Value<String?> lastMessageType = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsTableCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userIds: userIds,
            lastMessageText: lastMessageText,
            lastMessageUserId: lastMessageUserId,
            lastMessageType: lastMessageType,
            lastMessageAt: lastMessageAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            required String userIds,
            Value<String?> lastMessageText = const Value.absent(),
            Value<String?> lastMessageUserId = const Value.absent(),
            Value<String?> lastMessageType = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsTableCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userIds: userIds,
            lastMessageText: lastMessageText,
            lastMessageUserId: lastMessageUserId,
            lastMessageType: lastMessageType,
            lastMessageAt: lastMessageAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabaseImpl,
    $ChatsTableTable,
    ChatsTableData,
    $$ChatsTableTableFilterComposer,
    $$ChatsTableTableOrderingComposer,
    $$ChatsTableTableAnnotationComposer,
    $$ChatsTableTableCreateCompanionBuilder,
    $$ChatsTableTableUpdateCompanionBuilder,
    (
      ChatsTableData,
      BaseReferences<_$AppDatabaseImpl, $ChatsTableTable, ChatsTableData>
    ),
    ChatsTableData,
    PrefetchHooks Function()>;
typedef $$MessagesTableTableCreateCompanionBuilder = MessagesTableCompanion
    Function({
  required String id,
  required String chatId,
  Value<String?> userId,
  Value<String?> content,
  required String type,
  Value<String?> fileUrl,
  required DateTime createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});
typedef $$MessagesTableTableUpdateCompanionBuilder = MessagesTableCompanion
    Function({
  Value<String> id,
  Value<String> chatId,
  Value<String?> userId,
  Value<String?> content,
  Value<String> type,
  Value<String?> fileUrl,
  Value<DateTime> createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});

class $$MessagesTableTableFilterComposer
    extends Composer<_$AppDatabaseImpl, $MessagesTableTable> {
  $$MessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chatId => $composableBuilder(
      column: $table.chatId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));
}

class $$MessagesTableTableOrderingComposer
    extends Composer<_$AppDatabaseImpl, $MessagesTableTable> {
  $$MessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chatId => $composableBuilder(
      column: $table.chatId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));
}

class $$MessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabaseImpl, $MessagesTableTable> {
  $$MessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chatId =>
      $composableBuilder(column: $table.chatId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$MessagesTableTableTableManager extends RootTableManager<
    _$AppDatabaseImpl,
    $MessagesTableTable,
    MessagesTableData,
    $$MessagesTableTableFilterComposer,
    $$MessagesTableTableOrderingComposer,
    $$MessagesTableTableAnnotationComposer,
    $$MessagesTableTableCreateCompanionBuilder,
    $$MessagesTableTableUpdateCompanionBuilder,
    (
      MessagesTableData,
      BaseReferences<_$AppDatabaseImpl, $MessagesTableTable, MessagesTableData>
    ),
    MessagesTableData,
    PrefetchHooks Function()> {
  $$MessagesTableTableTableManager(
      _$AppDatabaseImpl db, $MessagesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chatId = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesTableCompanion(
            id: id,
            chatId: chatId,
            userId: userId,
            content: content,
            type: type,
            fileUrl: fileUrl,
            createdAt: createdAt,
            isRead: isRead,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chatId,
            Value<String?> userId = const Value.absent(),
            Value<String?> content = const Value.absent(),
            required String type,
            Value<String?> fileUrl = const Value.absent(),
            required DateTime createdAt,
            Value<bool> isRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesTableCompanion.insert(
            id: id,
            chatId: chatId,
            userId: userId,
            content: content,
            type: type,
            fileUrl: fileUrl,
            createdAt: createdAt,
            isRead: isRead,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessagesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabaseImpl,
    $MessagesTableTable,
    MessagesTableData,
    $$MessagesTableTableFilterComposer,
    $$MessagesTableTableOrderingComposer,
    $$MessagesTableTableAnnotationComposer,
    $$MessagesTableTableCreateCompanionBuilder,
    $$MessagesTableTableUpdateCompanionBuilder,
    (
      MessagesTableData,
      BaseReferences<_$AppDatabaseImpl, $MessagesTableTable, MessagesTableData>
    ),
    MessagesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseImplManager {
  final _$AppDatabaseImpl _db;
  $AppDatabaseImplManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$ChatsTableTableTableManager get chatsTable =>
      $$ChatsTableTableTableManager(_db, _db.chatsTable);
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db, _db.messagesTable);
}
