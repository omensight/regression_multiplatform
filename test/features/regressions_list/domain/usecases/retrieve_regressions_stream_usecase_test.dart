import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/features/regressions_list/domain/usecases/retrieve_regressions_stream_usecase.dart';

import '../../../../core/core_repository_mock.dart';

void main() {
  test('Test the regression are being retrieved from database', () async {
    final regressionDataSource = MockRegressionRepository();
    when(() => regressionDataSource.watchAll())
        .thenAnswer((_) => const Stream.empty());
    final retrieveRegressionsFromDatabaseUsecase =
        RetrieveRegressionsStreamUsecase(
      regressionRepository: regressionDataSource,
    );
    retrieveRegressionsFromDatabaseUsecase();
    verify(() => regressionDataSource.watchAll()).called(1);
  });
}
