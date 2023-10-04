import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'regression_dependent_variable.freezed.dart';

@Freezed()
class RegressionDependentVariable with _$RegressionDependentVariable {
  const factory RegressionDependentVariable({
    required String fkRegressionId,
    required String fkDataVariableId,
  }) = _DependentVariable;
}
