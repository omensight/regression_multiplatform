import 'package:drift/drift.dart';
import 'package:regression/core/data/entities/data_variables.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regressions.dart';

@UseRowClass(RegressionDependentVariable, generateInsertable: true)
class RegressionDependentVariables extends Table {
  TextColumn get fkRegressionId =>
      text().references(Regressions, #id, onDelete: KeyAction.cascade)();
  TextColumn get fkDataVariableId =>
      text().references(DataVariables, #id, onDelete: KeyAction.cascade)();
  @override
  Set<Column<Object>>? get primaryKey => {fkRegressionId};
}
