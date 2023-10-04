import 'package:drift/drift.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/regression_variable.dart';
import 'package:regression/core/data/entities/regression_variables.dart';

part 'regression_variable_data_source.g.dart';

@DriftAccessor(tables: [RegressionVariables])
class RegressionVariableDataSource extends DatabaseAccessor<RegressionDatabase>
    with _$RegressionVariableDataSourceMixin {
  RegressionVariableDataSource(super.attachedDatabase);

  Future<RegressionVariable> insert(RegressionVariable regressionVariable) {
    return into(regressionVariables)
        .insertReturning(regressionVariable.toInsertable());
  }
}
