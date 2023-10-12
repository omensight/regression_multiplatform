import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/entities/regression.dart';

class RegressionRepository {
  final RegressionDataSource regressionDataSource;

  RegressionRepository({required this.regressionDataSource});

  Stream<List<Regression>> watchAll() => regressionDataSource.watchAll();

  Future<Regression?> find(String regressionId) =>
      regressionDataSource.find(regressionId);

  Future<Regression?> findByName(String duplicatedName) =>
      regressionDataSource.findByName(duplicatedName);

  Future<Regression> duplicate(
          String originalRegressionId, String duplicatedName) =>
      regressionDataSource.duplicate(originalRegressionId, duplicatedName);

  Future<Regression> insert(
    String name,
    DateTime creationDateTime,
    RegressionType regressionType,
  ) {
    return regressionDataSource.insert(
      Regression(
        name: name,
        creationDateTime: creationDateTime,
        regressionType: regressionType,
      ),
    );
  }

  Future<int> deleteSingle(String id) => regressionDataSource.deleteSingle(id);
}
