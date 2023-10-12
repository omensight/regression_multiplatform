import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regression/core/data/constants.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/data_sources/regression_dependent_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_variable_data_source.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression_variable.dart';

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

  test('Test the regression can be deleted', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    final insertedRegression = await regressionDataSource.insert(regression);

    final affectedRows =
        await regressionDataSource.deleteSingle(insertedRegression.id);
    expect(affectedRows, 1);
  });

  test('Test wether the regression can be duplicated', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final dataVariableDataSource = DataVariableDataSource(regressionDatabase);
    final regressionVariableDataSource =
        RegressionVariableDataSource(regressionDatabase);
    final regressionDependentVariableDataSource =
        RegressionDependentVariableDataSource(regressionDatabase);

    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    final insertedRegression = await regressionDataSource.insert(regression);
    final dependentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV0', data: [0.5]));
    final independentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV1', data: [0.5]));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: dependentVariable.id));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: independentVariable.id));
    await regressionDependentVariableDataSource.insert(
        RegressionDependentVariable(
            fkRegressionId: insertedRegression.id,
            fkDataVariableId: dependentVariable.id));
    final duplicatedRegression =
        await regressionDataSource.duplicate(insertedRegression.id, 'new_name');
    expect(duplicatedRegression, isNotNull);
  });

  test('Test wether the regression can be duplicated with a new ID', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final dataVariableDataSource = DataVariableDataSource(regressionDatabase);
    final regressionVariableDataSource =
        RegressionVariableDataSource(regressionDatabase);
    final regressionDependentVariableDataSource =
        RegressionDependentVariableDataSource(regressionDatabase);

    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    final insertedRegression = await regressionDataSource.insert(regression);
    final dependentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV0', data: [0.5]));
    final independentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV1', data: [0.5]));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: dependentVariable.id));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: independentVariable.id));
    await regressionDependentVariableDataSource.insert(
        RegressionDependentVariable(
            fkRegressionId: insertedRegression.id,
            fkDataVariableId: dependentVariable.id));
    final duplicatedRegression =
        await regressionDataSource.duplicate(insertedRegression.id, 'new_name');
    expect(duplicatedRegression.id, isNot(krGeneratedPrimaryKey));
  });

  test('Test wether the regression variables have been duplicated', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final dataVariableDataSource = DataVariableDataSource(regressionDatabase);
    final regressionVariableDataSource =
        RegressionVariableDataSource(regressionDatabase);
    final regressionDependentVariableDataSource =
        RegressionDependentVariableDataSource(regressionDatabase);

    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    final insertedRegression = await regressionDataSource.insert(regression);
    final dependentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV0', data: [0.7]));
    final independentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV1', data: [0.5]));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: dependentVariable.id));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: independentVariable.id));
    await regressionDependentVariableDataSource.insert(
        RegressionDependentVariable(
            fkRegressionId: insertedRegression.id,
            fkDataVariableId: dependentVariable.id));

    final duplicatedRegression =
        await regressionDataSource.duplicate(insertedRegression.id, 'new_name');
    final duplicatedRegressionVariables = await regressionVariableDataSource
        .findAllByRegressionId(duplicatedRegression.id);
    expect(duplicatedRegressionVariables.length, 2);
  });

  test('Test wether the regression dependent variable have been duplicated ',
      () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final dataVariableDataSource = DataVariableDataSource(regressionDatabase);
    final regressionVariableDataSource =
        RegressionVariableDataSource(regressionDatabase);
    final regressionDependentVariableDataSource =
        RegressionDependentVariableDataSource(regressionDatabase);

    final regression = Regression(
      id: krGeneratedPrimaryKey,
      name: 'Regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    final insertedRegression = await regressionDataSource.insert(regression);
    final dependentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV0', data: [0.7]));
    final independentVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'DV1', data: [0.5]));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: dependentVariable.id));
    await regressionVariableDataSource.insert(RegressionVariable(
        fkRegressionId: insertedRegression.id,
        fkDataVariableId: independentVariable.id));
    await regressionDependentVariableDataSource.insert(
        RegressionDependentVariable(
            fkRegressionId: insertedRegression.id,
            fkDataVariableId: dependentVariable.id));

    final duplicatedRegression =
        await regressionDataSource.duplicate(insertedRegression.id, 'new_name');
    final duplicatedRegressionDependentVariable =
        await regressionDependentVariableDataSource
            .findByRegressionId(duplicatedRegression.id);
    expect(duplicatedRegressionDependentVariable, isNotNull);
  });
}
