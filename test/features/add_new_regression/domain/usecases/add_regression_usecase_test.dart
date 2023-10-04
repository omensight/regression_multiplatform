import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';
import 'package:regression/features/add_new_regression/domain/usecases/add_regression_usecase.dart';

import '../../../../core/core_mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Regression(
      name: 'name',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    ));
  });
  test('Test create regression returns a failure if there is a duplicated ID',
      () async {
    final regressionDataSource = MockRegressionsDataSource();
    when(() => regressionDataSource.findByName(any()))
        .thenAnswer((invocation) => Future(() => null));
    when(() => regressionDataSource.insert(any()))
        .thenThrow(SqliteException(1555, ''));
    final addRegressionUsecase =
        AddRegressionUsecase(regressionDataSource: regressionDataSource);
    final result =
        await addRegressionUsecase('regression_name', RegressionType.linear);
    CrudFailure? failure;
    result.fold((l) => failure = l, (r) => null);
    expect(failure, isA<CreateDuplicatedIdFailure>());
  });

  test('Test create regression returns a failure if there is a duplicated name',
      () async {
    final regressionDataSource = MockRegressionsDataSource();
    final existingRegression = Regression(
      name: 'name',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    when(() => regressionDataSource.findByName(any()))
        .thenAnswer((invocation) => Future(() => existingRegression));
    final addRegressionUsecase =
        AddRegressionUsecase(regressionDataSource: regressionDataSource);
    final result =
        await addRegressionUsecase('regression_name', RegressionType.linear);
    CrudFailure? failure;
    result.fold((l) => failure = l, (r) => null);
    expect(failure, isA<CreateDuplicatedNameFailure>());
  });

  test('Test create regression returns the created regression', () async {
    final regressionDataSource = MockRegressionsDataSource();
    final createdRegression = Regression(
      name: 'name',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    when(() => regressionDataSource.findByName(any()))
        .thenAnswer((invocation) => Future(() => null));
    when(() => regressionDataSource.insert(any()))
        .thenAnswer((invocation) => Future(() => createdRegression));
    final addRegressionUsecase =
        AddRegressionUsecase(regressionDataSource: regressionDataSource);
    final result = await addRegressionUsecase('name', RegressionType.linear);
    Regression? insertedRegression;
    result.fold((l) => null, (r) => insertedRegression = r);
    expect(insertedRegression, isNotNull);
  });
}
