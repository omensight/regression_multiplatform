import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';

import '../../core_mocks.dart';

void main() {
  test('Test the regression are being retrieved from database', () async {
    final regressionDataSource = MockRegressionsDataSource();
    when(() => regressionDataSource.watchAll())
        .thenAnswer((_) => const Stream.empty());
    final regressionRepository = RegressionRepository(
      regressionDataSource: regressionDataSource,
    );
    regressionRepository.watchAll();
    verify(() => regressionDataSource.watchAll()).called(1);
  });
}
