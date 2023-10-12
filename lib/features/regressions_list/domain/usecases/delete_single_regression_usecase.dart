import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';

class DeleteSingleRegressionUsecase {
  final RegressionRepository regressionDataSource;
  DeleteSingleRegressionUsecase({
    required this.regressionDataSource,
  });
  Future<Either<CrudFailure, String>> call({required String id}) async {
    final deletionResult = await regressionDataSource.deleteSingle(id);
    return deletionResult == 1
        ? Right(id)
        : Left(DeleteFailure(entityIdentifier: id));
  }
}
