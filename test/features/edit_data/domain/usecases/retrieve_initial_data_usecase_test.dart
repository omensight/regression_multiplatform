import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/features/edit_data/domain/usecases/failures/edit_data_failures.dart';
import 'package:regression/features/edit_data/domain/usecases/retrieve_initial_data_usecase.dart';

import '../../../../core/core_repository_mock.dart';

void main() {
  test('Test the retrieved data is a matrix', () async {
    final dataVariableRepository = MockDataVariableRepository();
    final retrieveInitialVariablesUsecase =
        RetrieveInitialRegressionDataUsecase(
            dataVariableRepository: dataVariableRepository);
    when(() => dataVariableRepository.getAllVariablesByRegressionId(any()))
        .thenAnswer(
      (invocation) => Future(
        () => [
          const DataVariable(
            label: 'label',
            data: [0, 1, 2, 3],
          ),
          const DataVariable(
            label: 'label',
            data: [4, 5, 6, 7],
          ),
        ],
      ),
    );
    List<List<double>> right = [];
    (await retrieveInitialVariablesUsecase('some_id'))
        .fold((l) => null, (r) => right = r);
    expect(right, [
      [0, 4],
      [1, 5],
      [2, 6],
      [3, 7],
    ]);
  });

  test(
      'Test wether is a failure if the data variables have not the same length',
      () async {
    final dataVariableRepository = MockDataVariableRepository();
    final retrieveInitialVariablesUsecase =
        RetrieveInitialRegressionDataUsecase(
            dataVariableRepository: dataVariableRepository);
    when(() => dataVariableRepository.getAllVariablesByRegressionId(any()))
        .thenAnswer(
      (invocation) => Future(
        () => [
          const DataVariable(
            label: 'label',
            data: [0, 1, 2, 3],
          ),
          const DataVariable(
            label: 'label',
            data: [4, 5, 6],
          ),
        ],
      ),
    );
    expect(await retrieveInitialVariablesUsecase('some_id'),
        isA<Left<EditDataFailure, List<List<double>>>>());
  });

  test('Test wether is a failure if the data variables are empty', () async {
    final dataVariableRepository = MockDataVariableRepository();
    final retrieveInitialVariablesUsecase =
        RetrieveInitialRegressionDataUsecase(
            dataVariableRepository: dataVariableRepository);
    when(() => dataVariableRepository.getAllVariablesByRegressionId(any()))
        .thenAnswer(
      (invocation) => Future(
        () => [
          const DataVariable(
            label: 'label',
            data: [],
          ),
          const DataVariable(
            label: 'label',
            data: [],
          ),
        ],
      ),
    );
    var result = (await retrieveInitialVariablesUsecase('some_id'))
        .fold((l) => l, (r) => r);
    expect(result, isA<EmptyDataVariablesFailure>());
  });
}
