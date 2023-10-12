import 'package:regression/core/data/data_sources/regression_dependent_variable_data_source.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';

class RegressionDependentVariableRepository {
  final RegressionDependentVariableDataSource
      regressionDependentVariableDataSource;

  RegressionDependentVariableRepository({
    required this.regressionDependentVariableDataSource,
  });

  Future<RegressionDependentVariable> insert(
          RegressionDependentVariable regressionDependentVariable) =>
      regressionDependentVariableDataSource.insert(regressionDependentVariable);
}
