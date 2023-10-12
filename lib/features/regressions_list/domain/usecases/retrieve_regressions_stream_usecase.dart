import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';

class RetrieveRegressionsStreamUsecase {
  final RegressionRepository regressionRepository;
  RetrieveRegressionsStreamUsecase({
    required this.regressionRepository,
  });
  Stream<List<Regression>> call() => regressionRepository.watchAll();
}
