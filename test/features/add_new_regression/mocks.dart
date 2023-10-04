import 'package:mocktail/mocktail.dart';
import 'package:regression/features/add_new_regression/domain/usecases/add_regression_usecase.dart';
import 'package:regression/features/add_new_regression/domain/usecases/add_regression_variable_usecase.dart';

class MockAddRegressionUsecase extends Mock implements AddRegressionUsecase {}

class MockAddRegressionVariableUsecase extends Mock
    implements AddRegressionVariableUsecase {}
