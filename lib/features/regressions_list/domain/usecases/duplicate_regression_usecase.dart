import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';

class DuplicateRegressionUsecase {
  final RegressionRepository regressionRepository;

  DuplicateRegressionUsecase({required this.regressionRepository});
  Future<Either<CrudFailure, Regression>> call({
    required String originalRegressionId,
    required String duplicatedName,
  }) async {
    Either<CrudFailure, Regression> result;
    final originalRegression =
        await regressionRepository.findByName(duplicatedName);
    if (originalRegression != null &&
        originalRegression.name == duplicatedName) {
      result = Left(CreateDuplicatedNameFailure(entityName: duplicatedName));
    } else {
      final duplicatedRegression = await regressionRepository.duplicate(
          originalRegressionId, duplicatedName);
      result = Right(duplicatedRegression);
    }

    return result;
  }
}
