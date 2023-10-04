import 'package:drift/drift.dart';
import 'package:regression/core/data/converters/double_list_converter.dart';
import 'package:regression/core/data/converters/primary_key_converter.dart';
import 'package:regression/core/data/entities/data_variable.dart';

@UseRowClass(DataVariable, generateInsertable: true)
class DataVariables extends Table {
  TextColumn get id => text().map(PrimaryKeyConverter())();
  TextColumn get label => text()();
  TextColumn get data => text().map(DoubleListConverter())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
