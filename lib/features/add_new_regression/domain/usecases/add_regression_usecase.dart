import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';

class AddRegressionUsecase {
  final RegressionDataSource regressionDataSource;

  AddRegressionUsecase({required this.regressionDataSource});

  Future<Either<CrudFailure, Regression>> call(
    String name,
    RegressionType regressionType,
  ) async {
    Either<CrudFailure, Regression> result;
    Regression? existingRegression =
        await regressionDataSource.findByName(name);
    if (existingRegression == null) {
      try {
        final insertedRegression = await regressionDataSource.insert(
          Regression(
            name: name,
            creationDateTime: DateTime.now(),
            regressionType: regressionType,
          ),
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
