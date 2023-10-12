import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression_variable.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';
import 'package:regression/features/add_new_regression/domain/usecases/add_regression_variable_usecase.dart';

import '../../../../core/core_mocks.dart';
import '../../../../core/core_repository_mock.dart';

void main() {
  setUp(() {
    registerFallbackValue(const DataVariable(label: 'label', data: []));
    registerFallbackValue(const RegressionDependentVariable(
        fkDataVariableId: 'fkDataVariableId',
        fkRegressionId: 'fkRegressionId'));
    registerFallbackValue(const RegressionVariable(
        fkDataVariableId: 'fkDataVariableId',
        fkRegressionId: 'fkRegressionId'));
  });
  test('Test the data variable have been created', () async {
    final dataVariableRepository = MockDataVariableRepository();
    when(() => dataVariableRepository.insert(any())).thenAnswer((invocation) =>
        Future(() => const DataVariable(label: 'label', data: [])));
    final regressionDependentVariableRepository =
        MockRegressionDependentVariableRepository();
    when(() => regressionDependentVariableRepository.insert(any())).thenAnswer(
      (invocation) => Future(
        () => const RegressionDependentVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId'),
      ),
    );
    final regressionVariableDataSource = MockRegressionVariableDataSource();
    when(() => regressionVariableDataSource.insert(any())).thenAnswer(
        (invocation) => Future(() => const RegressionVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId')));
    final addDependentRegressionVariableUsecase = AddRegressionVariableUsecase(
      dataVariableRepository: dataVariableRepository,
      regressionDependentVariableRepository:
          regressionDependentVariableRepository,
      regressionVariableDataSource: regressionVariableDataSource,
    );
    final result = await addDependentRegressionVariableUsecase(
      ownerRegressionId: 'regressionId',
      variableLabel: 'variable_name',
    );
    expect(result, isA<Right<CrudFailure, DataVariable>>());
  });

  test('Test the variable have been added as the dependent variable', () async {
    final dataVariableRepository = MockDataVariableRepository();
    final regressionDependentVariableRepository =
        MockRegressionDependentVariableRepository();
    when(() => regressionDependentVariableRepository.insert(any())).thenAnswer(
      (invocation) => Future(
        () => const RegressionDependentVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId'),
      ),
    );
    when(() => dataVariableRepository.insert(any())).thenAnswer((invocation) =>
        Future(() => const DataVariable(label: 'label', data: [])));
    final regressionVariableDataSource = MockRegressionVariableDataSource();
    when(() => regressionVariableDataSource.insert(any())).thenAnswer(
        (invocation) => Future(() => const RegressionVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId')));
    final addDependentRegressionVariableUsecase = AddRegressionVariableUsecase(
      dataVariableRepository: dataVariableRepository,
      regressionDependentVariableRepository:
          regressionDependentVariableRepository,
      regressionVariableDataSource: regressionVariableDataSource,
    );

    await addDependentRegressionVariableUsecase(
      ownerRegressionId: 'some_id',
      isDependent: true,
      variableLabel: 'variable_name',
    );
    verify(() => regressionDependentVariableRepository.insert(any())).called(1);
  });

  test('Test the regression variable have been inserted into the database',
      () async {
    final dataVariableRepository = MockDataVariableRepository();
    final regressionDependentVariableRepository =
        MockRegressionDependentVariableRepository();
    when(() => regressionDependentVariableRepository.insert(any())).thenAnswer(
      (invocation) => Future(
        () => const RegressionDependentVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId'),
      ),
    );
    when(() => dataVariableRepository.insert(any())).thenAnswer((invocation) =>
        Future(() => const DataVariable(label: 'label', data: [])));
    final regressionVariableDataSource = MockRegressionVariableDataSource();
    when(() => regressionVariableDataSource.insert(any())).thenAnswer(
        (invocation) => Future(() => const RegressionVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId')));
    final addDependentRegressionVariableUsecase = AddRegressionVariableUsecase(
      dataVariableRepository: dataVariableRepository,
      regressionDependentVariableRepository:
          regressionDependentVariableRepository,
      regressionVariableDataSource: regressionVariableDataSource,
    );

    await addDependentRegressionVariableUsecase(
      ownerRegressionId: 'some_id',
      variableLabel: 'variable_name',
    );
    verify(() => regressionVariableDataSource.insert(any())).called(1);
  });

  test('Test the dependent variable is only created if it is request',
      () async {
    final dataVariableRepository = MockDataVariableRepository();
    final regressionDependentVariableRepository =
        MockRegressionDependentVariableRepository();
    when(() => regressionDependentVariableRepository.insert(any())).thenAnswer(
      (invocation) => Future(
        () => const RegressionDependentVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId'),
      ),
    );
    when(() => dataVariableRepository.insert(any())).thenAnswer((invocation) =>
        Future(() => const DataVariable(label: 'label', data: [])));
    final regressionVariableDataSource = MockRegressionVariableDataSource();
    when(() => regressionVariableDataSource.insert(any())).thenAnswer(
        (invocation) => Future(() => const RegressionVariable(
            fkRegressionId: 'fkRegressionId',
            fkDataVariableId: 'fkDataVariableId')));
    final addDependentRegressionVariableUsecase = AddRegressionVariableUsecase(
      dataVariableRepository: dataVariableRepository,
      regressionDependentVariableRepository:
          regressionDependentVariableRepository,
      regressionVariableDataSource: regressionVariableDataSource,
    );

    await addDependentRegressionVariableUsecase(
      ownerRegressionId: 'some_id',
      isDependent: false,
      variableLabel: 'variable_name',
    );
    verifyNever(() => regressionDependentVariableRepository.insert(any()));
  });
}
