import 'package:regression/core/domain/failures/regression_failure.dart';

sealed class EditDataFailure extends RegressionFailure {
  EditDataFailure({required super.arguments});
}

class InconsistentDataVariableLengthsFailure extends EditDataFailure {
  InconsistentDataVariableLengthsFailure() : super(arguments: []);
}

class EmptyDataVariablesFailure extends EditDataFailure {
  EmptyDataVariablesFailure() : super(arguments: []);
}
