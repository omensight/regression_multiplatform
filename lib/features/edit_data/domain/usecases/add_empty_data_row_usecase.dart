import 'package:fpdart/fpdart.dart';
import 'package:regression/features/edit_data/domain/usecases/failures/edit_data_failures.dart';

class AddEmptyDataRowUsecase {
  Future<Either<EditDataFailure, List<List<double>>>> call(
    List<List<double>> previous,
    int originalLength,
  ) async {
    final copy = List.of(previous);
    for (var element in copy) {
      element.add(double.nan);
    }
    return Right(copy);
  }
}
