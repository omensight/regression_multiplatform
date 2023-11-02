import 'package:drift/drift.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/data_variables.dart';
import 'package:regression/core/data/entities/regression_variables.dart';
part 'data_variable_data_source.g.dart';

@DriftAccessor(tables: [DataVariables, RegressionVariables])
class DataVariableDataSource extends DatabaseAccessor<RegressionDatabase>
    with _$DataVariableDataSourceMixin {
  DataVariableDataSource(super.attachedDatabase);

  Future<DataVariable> insert(DataVariable dataVariable) {
    return into(dataVariables).insertReturning(dataVariable.toInsertable());
  }

  Future<List<DataVariable>> findAll() => select(dataVariables).get();

  Future<List<DataVariable>> getAllVariablesByRegressionId(
      String regressionId) async {
    final dataVariablesIds = await (select(regressionVariables)
          ..where((tbl) => tbl.fkRegressionId.equals(regressionId)))
        .map((regressionVariable) => regressionVariable.fkDataVariableId)
        .get();
    return (select(dataVariables)
          ..where((tbl) => tbl.id.isIn(dataVariablesIds)))
        .get();
  }
}
