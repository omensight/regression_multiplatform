import 'package:fpdart/fpdart.dart';
import 'package:regression/core/data/repositories/data_variable_repository.dart';
import 'package:regression/features/edit_data/domain/usecases/failures/edit_data_failures.dart';

class RetrieveInitialRegressionDataUsecase {
  final DataVariableRepository dataVariableRepository;

  const RetrieveInitialRegressionDataUsecase(
      {required this.dataVariableRepository});

  Future<Either<EditDataFailure, List<List<double>>>> call(
    String regressionId,
  ) async {
    Either<EditDataFailure, List<List<double>>> result =
        Left(InconsistentDataVariableLengthsFailure());

    final columns = (await dataVariableRepository
            .getAllVariablesByRegressionId(regressionId))
        .map((e) => e.data)
        .toList();

    final equalLengths = _equalLengths(columns);
    final emptyDataVariables = columns.map((e) => e.length).contains(0);
    if (emptyDataVariables) {
      result = Left(EmptyDataVariablesFailure());
    }
    if (equalLengths && !emptyDataVariables) {
      result = Right(_rotateMatrix(columns));
    }
    return result;
  }

  bool _equalLengths(List<List<double>> columns) {
    final firstDataColumnLenght = columns[0].length;
    int index = 1;
    bool equalLengths = true;
    while (index < columns.length && equalLengths) {
      equalLengths = columns[index].length == firstDataColumnLenght;
      index++;
    }
    return equalLengths;
  }

  List<List<double>> _rotateMatrix(List<List<double>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    List<List<double>> rotatedMatrix =
        List.generate(cols, (i) => List.generate(rows, (j) => 0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        rotatedMatrix[j][rows - 1 - i] = matrix[i][j];
      }
    }

    for (var i = 0; i < rotatedMatrix.length; i++) {
      rotatedMatrix[i] = rotatedMatrix[i].reversed.toList();
    }

    return rotatedMatrix;
  }
}
