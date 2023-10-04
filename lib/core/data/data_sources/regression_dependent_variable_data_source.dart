import 'package:drift/drift.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variables.dart';

part 'regression_dependent_variable_data_source.g.dart';

@DriftAccessor(tables: [RegressionDependentVariables])
class RegressionDependentVariableDataSource
    extends DatabaseAccessor<RegressionDatabase>
    with _$RegressionDependentVariableDataSourceMixin {
  RegressionDependentVariableDataSource(super.attachedDatabase);

  Future<RegressionDependentVariable> insert(
      RegressionDependentVariable regressionDependentVariable) {
    return into(regressionDependentVariables)
        .insertReturning(regressionDependentVariable.toInsertable());
  }
}
