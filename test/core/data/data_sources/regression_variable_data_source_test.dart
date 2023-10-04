import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/data_sources/regression_variable_data_source.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/entities/regression_variable.dart';

void main() {
  late RegressionDatabase regressionDatabase;
  setUp(() {
    regressionDatabase = RegressionDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() {
    regressionDatabase.close();
  });

  test('Test a variable entity is being created', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final dataVariableDataSource = DataVariableDataSource(regressionDatabase);
    final dependentVariableDataSource =
        RegressionVariableDataSource(regressionDatabase);
    final insertedRegression = await regressionDataSource.insert(Regression(
        name: 'name',
        creationDateTime: DateTime.now(),
        regressionType: RegressionType.linear));
    final insertedDataVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'dv_label', data: []));
    final insertedDependentVariable = await dependentVariableDataSource.insert(
        RegressionVariable(
            fkRegressionId: insertedRegression.id,
            fkDataVariableId: insertedDataVariable.id));
    expect(insertedDependentVariable.fkRegressionId, insertedRegression.id);
  });
}
