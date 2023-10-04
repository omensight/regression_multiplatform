import 'package:drift/drift.dart';
import 'package:regression/core/data/converters/date_converter.dart';
import 'package:regression/core/data/converters/primary_key_converter.dart';
import 'package:regression/core/data/converters/regression_type_converter.dart';
import 'package:regression/core/data/entities/regression.dart';

@UseRowClass(Regression, generateInsertable: true)
class Regressions extends Table {
  TextColumn get id => text().map(PrimaryKeyConverter())();
  TextColumn get name => text()();
  TextColumn get creationDateTime => text().map(DateConverter())();
  IntColumn get regressionType => integer().map(RegressionTypeConverter())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
