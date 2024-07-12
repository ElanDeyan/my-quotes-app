// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes_drift_database.dart';

// ignore_for_file: type=lint
class $QuoteTableTable extends QuoteTable
    with TableInfo<$QuoteTableTable, Quote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content =
      GeneratedColumn<String>('content', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author =
      GeneratedColumn<String>('author', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceUriMeta =
      const VerificationMeta('sourceUri');
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
      'source_uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, content, author, source, sourceUri, isFavorite, createdAt, tags];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_table';
  @override
  VerificationContext validateIntegrity(Insertable<Quote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('source_uri')) {
      context.handle(_sourceUriMeta,
          sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      sourceUri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_uri']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
    );
  }

  @override
  $QuoteTableTable createAlias(String alias) {
    return $QuoteTableTable(attachedDatabase, alias);
  }
}

class Quote extends DataClass implements Insertable<Quote> {
  final int? id;
  final String content;
  final String author;
  final String? source;
  final String? sourceUri;
  final bool isFavorite;
  final DateTime? createdAt;
  final String? tags;
  const Quote(
      {this.id,
      required this.content,
      required this.author,
      this.source,
      this.sourceUri,
      required this.isFavorite,
      this.createdAt,
      this.tags});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['content'] = Variable<String>(content);
    map['author'] = Variable<String>(author);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || sourceUri != null) {
      map['source_uri'] = Variable<String>(sourceUri);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    return map;
  }

  QuoteTableCompanion toCompanion(bool nullToAbsent) {
    return QuoteTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      content: Value(content),
      author: Value(author),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      sourceUri: sourceUri == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUri),
      isFavorite: Value(isFavorite),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quote(
      id: serializer.fromJson<int?>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      author: serializer.fromJson<String>(json['author']),
      source: serializer.fromJson<String?>(json['source']),
      sourceUri: serializer.fromJson<String?>(json['sourceUri']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      tags: serializer.fromJson<String?>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'content': serializer.toJson<String>(content),
      'author': serializer.toJson<String>(author),
      'source': serializer.toJson<String?>(source),
      'sourceUri': serializer.toJson<String?>(sourceUri),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'tags': serializer.toJson<String?>(tags),
    };
  }

  Quote copyWith(
          {Value<int?> id = const Value.absent(),
          String? content,
          String? author,
          Value<String?> source = const Value.absent(),
          Value<String?> sourceUri = const Value.absent(),
          bool? isFavorite,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<String?> tags = const Value.absent()}) =>
      Quote(
        id: id.present ? id.value : this.id,
        content: content ?? this.content,
        author: author ?? this.author,
        source: source.present ? source.value : this.source,
        sourceUri: sourceUri.present ? sourceUri.value : this.sourceUri,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        tags: tags.present ? tags.value : this.tags,
      );
  @override
  String toString() {
    return (StringBuffer('Quote(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('author: $author, ')
          ..write('source: $source, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, content, author, source, sourceUri, isFavorite, createdAt, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quote &&
          other.id == this.id &&
          other.content == this.content &&
          other.author == this.author &&
          other.source == this.source &&
          other.sourceUri == this.sourceUri &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.tags == this.tags);
}

class QuoteTableCompanion extends UpdateCompanion<Quote> {
  final Value<int?> id;
  final Value<String> content;
  final Value<String> author;
  final Value<String?> source;
  final Value<String?> sourceUri;
  final Value<bool> isFavorite;
  final Value<DateTime?> createdAt;
  final Value<String?> tags;
  const QuoteTableCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.author = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.tags = const Value.absent(),
  });
  QuoteTableCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required String author,
    this.source = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.tags = const Value.absent(),
  })  : content = Value(content),
        author = Value(author);
  static Insertable<Quote> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? author,
    Expression<String>? source,
    Expression<String>? sourceUri,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<String>? tags,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (author != null) 'author': author,
      if (source != null) 'source': source,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (tags != null) 'tags': tags,
    });
  }

  QuoteTableCompanion copyWith(
      {Value<int?>? id,
      Value<String>? content,
      Value<String>? author,
      Value<String?>? source,
      Value<String?>? sourceUri,
      Value<bool>? isFavorite,
      Value<DateTime?>? createdAt,
      Value<String?>? tags}) {
    return QuoteTableCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      source: source ?? this.source,
      sourceUri: sourceUri ?? this.sourceUri,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuoteTableCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('author: $author, ')
          ..write('source: $source, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }
}

class $TagTableTable extends TagTable with TableInfo<$TagTableTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_table';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $TagTableTable createAlias(String alias) {
    return $TagTableTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int? id;
  final String name;
  const Tag({this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['name'] = Variable<String>(name);
    return map;
  }

  TagTableCompanion toCompanion(bool nullToAbsent) {
    return TagTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: Value(name),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int?>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({Value<int?> id = const Value.absent(), String? name}) => Tag(
        id: id.present ? id.value : this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagTableCompanion extends UpdateCompanion<Tag> {
  final Value<int?> id;
  final Value<String> name;
  const TagTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagTableCompanion copyWith({Value<int?>? id, Value<String>? name}) {
    return TagTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $QuoteTableTable quoteTable = $QuoteTableTable(this);
  late final $TagTableTable tagTable = $TagTableTable(this);
  late final QuotesDao quotesDao = QuotesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [quoteTable, tagTable];
}

typedef $$QuoteTableTableInsertCompanionBuilder = QuoteTableCompanion Function({
  Value<int?> id,
  required String content,
  required String author,
  Value<String?> source,
  Value<String?> sourceUri,
  Value<bool> isFavorite,
  Value<DateTime?> createdAt,
  Value<String?> tags,
});
typedef $$QuoteTableTableUpdateCompanionBuilder = QuoteTableCompanion Function({
  Value<int?> id,
  Value<String> content,
  Value<String> author,
  Value<String?> source,
  Value<String?> sourceUri,
  Value<bool> isFavorite,
  Value<DateTime?> createdAt,
  Value<String?> tags,
});

class $$QuoteTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuoteTableTable,
    Quote,
    $$QuoteTableTableFilterComposer,
    $$QuoteTableTableOrderingComposer,
    $$QuoteTableTableProcessedTableManager,
    $$QuoteTableTableInsertCompanionBuilder,
    $$QuoteTableTableUpdateCompanionBuilder> {
  $$QuoteTableTableTableManager(_$AppDatabase db, $QuoteTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$QuoteTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$QuoteTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$QuoteTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int?> id = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> author = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> sourceUri = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<String?> tags = const Value.absent(),
          }) =>
              QuoteTableCompanion(
            id: id,
            content: content,
            author: author,
            source: source,
            sourceUri: sourceUri,
            isFavorite: isFavorite,
            createdAt: createdAt,
            tags: tags,
          ),
          getInsertCompanionBuilder: ({
            Value<int?> id = const Value.absent(),
            required String content,
            required String author,
            Value<String?> source = const Value.absent(),
            Value<String?> sourceUri = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<String?> tags = const Value.absent(),
          }) =>
              QuoteTableCompanion.insert(
            id: id,
            content: content,
            author: author,
            source: source,
            sourceUri: sourceUri,
            isFavorite: isFavorite,
            createdAt: createdAt,
            tags: tags,
          ),
        ));
}

class $$QuoteTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $QuoteTableTable,
    Quote,
    $$QuoteTableTableFilterComposer,
    $$QuoteTableTableOrderingComposer,
    $$QuoteTableTableProcessedTableManager,
    $$QuoteTableTableInsertCompanionBuilder,
    $$QuoteTableTableUpdateCompanionBuilder> {
  $$QuoteTableTableProcessedTableManager(super.$state);
}

class $$QuoteTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $QuoteTableTable> {
  $$QuoteTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get author => $state.composableBuilder(
      column: $state.table.author,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sourceUri => $state.composableBuilder(
      column: $state.table.sourceUri,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$QuoteTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $QuoteTableTable> {
  $$QuoteTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get author => $state.composableBuilder(
      column: $state.table.author,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceUri => $state.composableBuilder(
      column: $state.table.sourceUri,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TagTableTableInsertCompanionBuilder = TagTableCompanion Function({
  Value<int?> id,
  required String name,
});
typedef $$TagTableTableUpdateCompanionBuilder = TagTableCompanion Function({
  Value<int?> id,
  Value<String> name,
});

class $$TagTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagTableTable,
    Tag,
    $$TagTableTableFilterComposer,
    $$TagTableTableOrderingComposer,
    $$TagTableTableProcessedTableManager,
    $$TagTableTableInsertCompanionBuilder,
    $$TagTableTableUpdateCompanionBuilder> {
  $$TagTableTableTableManager(_$AppDatabase db, $TagTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TagTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TagTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TagTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int?> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              TagTableCompanion(
            id: id,
            name: name,
          ),
          getInsertCompanionBuilder: ({
            Value<int?> id = const Value.absent(),
            required String name,
          }) =>
              TagTableCompanion.insert(
            id: id,
            name: name,
          ),
        ));
}

class $$TagTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $TagTableTable,
    Tag,
    $$TagTableTableFilterComposer,
    $$TagTableTableOrderingComposer,
    $$TagTableTableProcessedTableManager,
    $$TagTableTableInsertCompanionBuilder,
    $$TagTableTableUpdateCompanionBuilder> {
  $$TagTableTableProcessedTableManager(super.$state);
}

class $$TagTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TagTableTable> {
  $$TagTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TagTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TagTableTable> {
  $$TagTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$QuoteTableTableTableManager get quoteTable =>
      $$QuoteTableTableTableManager(_db, _db.quoteTable);
  $$TagTableTableTableManager get tagTable =>
      $$TagTableTableTableManager(_db, _db.tagTable);
}
