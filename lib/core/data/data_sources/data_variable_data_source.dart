import 'package:drift/drift.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/data_variables.dart';
part 'data_variable_data_source.g.dart';

@DriftAccessor(tables: [DataVariables])
class DataVariableDataSource extends DatabaseAccessor<RegressionDatabase>
    with _$DataVariableDataSourceMixin {
  DataVariableDataSource(super.attachedDatabase);

  Future<DataVariable> insert(DataVariable dataVariable) {
    return into(dataVariables).insertReturning(dataVariable.toInsertable());
  }
}
