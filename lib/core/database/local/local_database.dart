import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'local_database.g.dart';

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().nullable().references(Plans, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime().nullable()();
}

class Plans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueAt => dateTime()();
}

class PlanTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(Plans, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();
  @override
  List<Set<Column>> get uniqueKeys => [ {planId, tagId} ];
}

class Journals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class JournalTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get journalId => integer().references(Journals, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();
  @override
  List<Set<Column>> get uniqueKeys => [ {journalId, tagId} ];
}

@DriftDatabase(tables: [Todos, Tags, Plans, PlanTags, Journals, JournalTags])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'elcinorhc_database.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}