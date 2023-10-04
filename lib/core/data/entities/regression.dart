import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:regression/core/data/constants.dart';

part 'regression.freezed.dart';

@Freezed()
class Regression with _$Regression {
  const factory Regression({
    @Default(krGeneratedPrimaryKey) String id,
    required String name,
    required DateTime creationDateTime,
    required RegressionType regressionType,
  }) = _Regression;
}

enum RegressionType {
  linear,
  power,
}
