import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/data_sources/regression_variable_data_source.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression_variable.dart';
import 'package:regression/core/data/repositories/data_variable_repository.dart';
import 'package:regression/core/data/repositories/regression_dependent_variable_repository.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';

class AddRegressionVariableUsecase {
  final DataVariableRepository dataVariableRepository;
  final RegressionDependentVariableRepository
      regressionDependentVariableRepository;
  final RegressionVariableDataSource regressionVariableDataSource;
  AddRegressionVariableUsecase({
    required this.dataVariableRepository,
    required this.regressionDependentVariableRepository,
    required this.regressionVariableDataSource,
  });

  Future<Either<CrudFailure, DataVariable>> call({
    required String ownerRegressionId,
    required String variableLabel,
    bool isDependent = false,
  }) async {
    final insertedDataVariable = await dataVariableRepository
        .insert(DataVariable(label: variableLabel, data: []));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: ownerRegressionId,
        fkDataVariableId: insertedDataVariable.id));
    if (isDependent) {
      await regressionDependentVariableRepository
          .insert(RegressionDependentVariable(
        fkRegressionId: ownerRegressionId,
        fkDataVariableId: insertedDataVariable.id,
      ));
    }
    return Right(insertedDataVariable);
  }
}
