import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regression/core/data/constants.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variable.dart';

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
}
