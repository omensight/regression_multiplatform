import 'package:drift/drift.dart';
import 'package:regression/core/data/entities/data_variables.dart';
import 'package:regression/core/data/entities/regression_variable.dart';
import 'package:regression/core/data/entities/regressions.dart';

@UseRowClass(RegressionVariable, generateInsertable: true)
class RegressionVariables extends Table {
  TextColumn get fkRegressionId => text().references(Regressions, #id)();
  TextColumn get fkDataVariableId => text().references(DataVariables, #id)();
  @override
  Set<Column<Object>>? get primaryKey => {fkRegressionId, fkDataVariableId};
}
