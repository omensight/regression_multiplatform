import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regression/core/data/constants.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/data_sources/regression_variable_data_source.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/entities/regression_variable.dart';

void main() {
  late RegressionDatabase database;
  setUp(() => database = RegressionDatabase(executor: NativeDatabase.memory()));
  tearDown(() => database.close());
  test('Test a data variable have been inserted into the database', () async {
    final dataSource = DataVariableDataSource(database);
    const dataVariable = DataVariable(label: 'label', data: []);
    final returnedVariable = await dataSource.insert(dataVariable);
    expect(returnedVariable.id, isNot(krGeneratedPrimaryKey));
  });

  test('Test a data variable have the correct data', () async {
    final dataSource = DataVariableDataSource(database);
    const dataVariable = DataVariable(label: 'label', data: [24.56]);
    final returnedVariable = await dataSource.insert(dataVariable);
    expect(returnedVariable.data.first, 24.56);
  });

  test(
      'Test wether the data variables related to a regression are being retrieved',
      () async {
    final dataVariableDataSource = DataVariableDataSource(database);
    final regressionDataSource = RegressionDataSource(database);
    final regressionVariableDataSource = RegressionVariableDataSource(database);
    final regression = Regression(
      name: 'regression',
      creationDateTime: DateTime.now(),
      regressionType: RegressionType.linear,
    );
    const dataVariable0 = DataVariable(label: 'label_0', data: [24.56]);
    const dataVariable1 = DataVariable(label: 'label_1', data: [24.56]);
    final insertedDataVariable0 =
        await dataVariableDataSource.insert(dataVariable0);

    final insertedDataVariable1 =
        await dataVariableDataSource.insert(dataVariable1);
    final insertedRegression = await regressionDataSource.insert(regression);

    final regressionVariable0 = RegressionVariable(
      fkRegressionId: insertedRegression.id,
      fkDataVariableId: insertedDataVariable0.id,
    );

    final regressionVariable1 = RegressionVariable(
      fkRegressionId: insertedRegression.id,
      fkDataVariableId: insertedDataVariable1.id,
    );

    await regressionVariableDataSource.insert(regressionVariable0);
    await regressionVariableDataSource.insert(regressionVariable1);
    final regressionVariables = await dataVariableDataSource
        .getAllVariablesByRegressionId(insertedRegression.id);
    expect(regressionVariables.length, 2);
  });
}
