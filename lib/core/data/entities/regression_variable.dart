import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'regression_variable.freezed.dart';

@Freezed()
class RegressionVariable with _$RegressionVariable {
  const factory RegressionVariable({
    required String fkRegressionId,
    required String fkDataVariableId,
  }) = _RegressionVariable;
}
