import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_dependent_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression.dart';

void main() {
  late RegressionDatabase regressionDatabase;
  setUp(() {
    regressionDatabase = RegressionDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() {
    regressionDatabase.close();
  });

  test('Test a dependentVariable is being created', () async {
    final regressionDataSource = RegressionDataSource(regressionDatabase);
    final dataVariableDataSource = DataVariableDataSource(regressionDatabase);
    final dependentVariableDataSource =
        RegressionDependentVariableDataSource(regressionDatabase);
    final insertedRegression = await regressionDataSource.insert(Regression(
        name: 'name',
        creationDateTime: DateTime.now(),
        regressionType: RegressionType.linear));
    final insertedDataVariable = await dataVariableDataSource
        .insert(const DataVariable(label: 'dv_label', data: []));
    final insertedDependentVariable = await dependentVariableDataSource.insert(
        RegressionDependentVariable(
            fkRegressionId: insertedRegression.id,
            fkDataVariableId: insertedDataVariable.id));
    expect(insertedDependentVariable.fkRegressionId, insertedRegression.id);
  });
}
