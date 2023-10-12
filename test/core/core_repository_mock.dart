import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/repositories/data_variable_repository.dart';
import 'package:regression/core/data/repositories/regression_dependent_variable_repository.dart';
import 'package:regression/core/data/repositories/regression_repository.dart';

class MockRegressionRepository extends Mock implements RegressionRepository {}

class MockDataVariableRepository extends Mock
    implements DataVariableRepository {}

class MockRegressionDependentVariableRepository extends Mock
    implements RegressionDependentVariableRepository {}
