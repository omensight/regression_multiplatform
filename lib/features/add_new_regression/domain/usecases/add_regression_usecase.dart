import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';

class AddRegressionUsecase {
  final RegressionRepository regressionRepository;

  AddRegressionUsecase({required this.regressionRepository});

  Future<Either<CrudFailure, Regression>> call(
    String name,
    RegressionType regressionType,
  ) async {
    Either<CrudFailure, Regression> result;
    Regression? existingRegression =
        await regressionRepository.findByName(name);
    if (existingRegression == null) {
      try {
        final insertedRegression = await regressionRepository.insert(
          name,
          DateTime.now(),
          regressionType,
        );
        result = Right(insertedRegression);
      } catch (e) {
        result = Left(CreateDuplicatedIdFailure(entityIdentifier: name));
      }
    } else {
      result = Left(CreateDuplicatedNameFailure(entityName: name));
    }
    return result;
  }
}
