import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/entities/data_variable.dart';

class DataVariableRepository {
  DataVariableDataSource dataVariableDataSource;

  DataVariableRepository({required this.dataVariableDataSource});

  Future<DataVariable> insert(DataVariable dataVariable) =>
      dataVariableDataSource.insert(dataVariable);

  Future<List<DataVariable>> getAllVariablesByRegressionId(
    String regressionId,
  ) =>
      dataVariableDataSource.getAllVariablesByRegressionId(regressionId);
}
