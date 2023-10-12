import 'package:regression/core/data/repositories/data_variable_repository.dart';
import 'package:regression/core/data/repositories/regression_dependent_variable_repository.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';
import 'package:regression/core/presentation/providers/database_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'repository_providers.g.dart';

@riverpod
RegressionRepository regressionRepository(RegressionRepositoryRef ref) {
  return RegressionRepository(
      regressionDataSource: ref.watch(regressionDataSourceProvider));
}

@riverpod
DataVariableRepository dataVariableRepository(DataVariableRepositoryRef ref) {
  return DataVariableRepository(
      dataVariableDataSource: ref.watch(dataVariableDataSourceProvider));
}

@riverpod
RegressionDependentVariableRepository regressionDependentVariableRepository(
    RegressionDependentVariableRepositoryRef ref) {
  return RegressionDependentVariableRepository(
      regressionDependentVariableDataSource:
          ref.watch(regressionDependentVariableDataSourceProvider));
}
