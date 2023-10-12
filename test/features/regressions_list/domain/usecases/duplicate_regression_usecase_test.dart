import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';
import 'package:regression/features/regressions_list/domain/usecases/duplicate_regression_usecase.dart';

import '../../../../core/core_repository_mock.dart';

void main() {
  test('Test the regression can be duplicated', () async {
    final regressionRepository = MockRegressionRepository();
    when(() => regressionRepository.duplicate(any(), any())).thenAnswer(
        (invocation) => Future(() => Regression(
            name: 'duplicated_regression',
            creationDateTime: DateTime.now(),
            regressionType: RegressionType.linear)));
    when(() => regressionRepository.findByName(any()))
        .thenAnswer((invocation) => Future(() => null));
    final duplicateRegressionUsecase =
        DuplicateRegressionUsecase(regressionRepository: regressionRepository);
    await duplicateRegressionUsecase(
        originalRegressionId: 'some_id', duplicatedName: 'New regression');
    verify(() => regressionRepository.duplicate(any(), any())).called(1);
  });

  test('Test the regression returns a failure if the name is duplicated',
      () async {
    final regressionDataSource = MockRegressionRepository();
    when(() => regressionDataSource.duplicate(any(), any())).thenAnswer(
        (invocation) => Future(() => Regression(
            name: 'duplicated_regression',
            creationDateTime: DateTime.now(),
            regressionType: RegressionType.linear)));

    when(() => regressionDataSource.findByName(any())).thenAnswer(
      (invocation) => Future(
        () => Regression(
            name: 'original_regression',
            creationDateTime: DateTime.now(),
            regressionType: RegressionType.linear),
      ),
    );
    final duplicateRegressionUsecase =
        DuplicateRegressionUsecase(regressionRepository: regressionDataSource);
    final duplicationResult = await duplicateRegressionUsecase(
      originalRegressionId: 'some_id',
      duplicatedName: 'original_regression',
    );
    final result = duplicationResult.getLeft().match(() => null, (t) => t);
    expect(
      result,
      isA<CreateDuplicatedNameFailure>(),
    );
  });
}
