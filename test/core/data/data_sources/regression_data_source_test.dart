import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regression/core/data/constants.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/regression.dart';

void main() {
  late RegressionDatabase regressionDatabase;
  setUp(() {
    regressionDatabase = RegressionDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() {
    regressionDatabase.close();
  });

  test('Test the data source creates a regression', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final regression = Regression(
      id: '',
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    final returnedRegression = await regressionDataSource.insert(regression);
    final foundedRegression =
        await regressionDataSource.find(returnedRegression.id);
    expect(foundedRegression, isNotNull);
  });

  test('Test the id is not empty', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    final returnedRegression = await regressionDataSource.insert(regression);
    expect(returnedRegression.id, isNotEmpty);
  });

  test('Test the regression can be founded by name', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    await regressionDataSource.insert(regression);
    final regressionFoundedByName =
        regressionDataSource.findByName(regression.name);
    expect(regressionFoundedByName, isNotNull);
  });
  test('Test the regression can be founded by name even if it is not trimmed',
      () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    await regressionDataSource.insert(regression);
    final regressionFoundedByName =
        await regressionDataSource.findByName('Regression ');
    expect(regressionFoundedByName, isNotNull);
  });

  test('Test the regression can be founded by name with no case sensitive',
      () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    await regressionDataSource.insert(regression);
    final regressionFoundedByName =
        await regressionDataSource.findByName('regression ');
    expect(regressionFoundedByName, isNotNull);
  });
}
