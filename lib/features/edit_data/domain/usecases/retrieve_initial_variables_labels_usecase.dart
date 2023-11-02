import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/repositories/data_variable_repository.dart';
import 'package:regression/features/edit_data/domain/usecases/failures/edit_data_failures.dart';

class RetrieveinitialVariablesLabelsUsecase {
  final DataVariableRepository dataVariableRepository;
  RetrieveinitialVariablesLabelsUsecase({required this.dataVariableRepository});
  Future<Either<EditDataFailure, List<String>>> call(
      String regressionId) async {
    final dataVariables = await dataVariableRepository
        .getAllVariablesByRegressionId(regressionId);
    return Right(dataVariables.map((e) => e.label).toList());
  }
}
