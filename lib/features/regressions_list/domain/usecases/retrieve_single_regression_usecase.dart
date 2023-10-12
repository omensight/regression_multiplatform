import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';

class RetrieveSingleRegressionUsecase {
  final RegressionRepository regressionRepository;

  RetrieveSingleRegressionUsecase({required this.regressionRepository});

  Future<Either<CrudFailure, Regression>> call(String regressionId) async {
    final regression = await regressionRepository.find(regressionId);
    return regression == null
        ? Left(ReadFailure(entityIdentifier: regressionId))
        : Right(regression);
  }
}
