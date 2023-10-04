import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/data_sources/regression_dependent_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_variable_data_source.dart';

class MockRegressionsDataSource extends Mock implements RegressionDataSource {}

class MockDataVariableDataSource extends Mock
    implements DataVariableDataSource {}

class MockRegressionDependentVariableDataSource extends Mock
    implements RegressionDependentVariableDataSource {}

class MockRegressionVariableDataSource extends Mock
    implements RegressionVariableDataSource {}

class MockGlobalKey<T extends State<StatefulWidget>> extends Mock
    implements GlobalKey<T> {}

class MockFormState extends Mock implements FormState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

GlobalKey<FormState> createMockGlobalFormStateKey({bool isValid = true}) {
  final key = MockGlobalKey<FormState>();
  final formState = MockFormState();
  when(() => formState.validate()).thenReturn(isValid);
  when(() => key.currentState).thenReturn(formState);
  return key;
}
