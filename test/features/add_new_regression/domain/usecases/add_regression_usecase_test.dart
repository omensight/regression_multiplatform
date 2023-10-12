import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';
import 'package:regression/features/add_new_regression/domain/usecases/add_regression_usecase.dart';

import '../../../../core/core_repository_mock.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(RegressionType.linear);
  });

  setUpAll(() {
    registerFallbackValue(Regression(
      name: 'name',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    ));
  });
  test('Test create regression returns a failure if there is a duplicated ID',
      () async {
    final regressionRepository = MockRegressionRepository();
    when(() => regressionRepository.findByName(any()))
        .thenAnswer((invocation) => Future(() => null));
    when(() => regressionRepository.insert(any(), any(), any()))
        .thenThrow(SqliteException(1555, ''));
    final addRegressionUsecase =
        AddRegressionUsecase(regressionRepository: regressionRepository);
    final result =
        await addRegressionUsecase('regression_name', RegressionType.linear);
    CrudFailure? failure;
    result.fold((l) => failure = l, (r) => null);
    expect(failure, isA<CreateDuplicatedIdFailure>());
  });

  test('Test create regression returns a failure if there is a duplicated name',
      () async {
    final regressionDataSource = MockRegressionRepository();
    final existingRegression = Regression(
      name: 'name',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    when(() => regressionDataSource.findByName(any()))
        .thenAnswer((invocation) => Future(() => existingRegression));
    final addRegressionUsecase =
        AddRegressionUsecase(regressionRepository: regressionDataSource);
    final result =
        await addRegressionUsecase('regression_name', RegressionType.linear);
    CrudFailure? failure;
    result.fold((l) => failure = l, (r) => null);
    expect(failure, isA<CreateDuplicatedNameFailure>());
  });

  test('Test create regression returns the created regression', () async {
    final regressionRepository = MockRegressionRepository();
    final createdRegression = Regression(
      name: 'name',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    when(() => regressionRepository.findByName(any()))
        .thenAnswer((invocation) => Future(() => null));
    when(() => regressionRepository.insert(any(), any(), any()))
        .thenAnswer((invocation) => Future(() => createdRegression));
    final addRegressionUsecase =
        AddRegressionUsecase(regressionRepository: regressionRepository);
    final result = await addRegressionUsecase('name', RegressionType.linear);
    Regression? insertedRegression;
    result.fold((l) => null, (r) => insertedRegression = r);
    expect(insertedRegression, isNotNull);
  });
}
