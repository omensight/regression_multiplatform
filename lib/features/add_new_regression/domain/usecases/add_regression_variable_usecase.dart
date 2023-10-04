import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_dependent_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_variable_data_source.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression_variable.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';

class AddRegressionVariableUsecase {
  final DataVariableDataSource dataVariableDataSource;
  final RegressionDependentVariableDataSource
      regressionDependentVariableDataSource;
  final RegressionVariableDataSource regressionVariableDataSource;
  AddRegressionVariableUsecase({
    required this.dataVariableDataSource,
    required this.regressionDependentVariableDataSource,
    required this.regressionVariableDataSource,
  });

  Future<Either<CrudFailure, DataVariable>> call({
    required String ownerRegressionId,
    required String variableLabel,
    bool isDependent = false,
  }) async {
    final insertedDataVariable = await dataVariableDataSource
        .insert(DataVariable(label: variableLabel, data: []));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: ownerRegressionId,
        fkDataVariableId: insertedDataVariable.id));
    if (isDependent) {
      await regressionDependentVariableDataSource
          .insert(RegressionDependentVariable(
        fkRegressionId: ownerRegressionId,
        fkDataVariableId: insertedDataVariable.id,
      ));
    }
    return Right(insertedDataVariable);
  }
}
