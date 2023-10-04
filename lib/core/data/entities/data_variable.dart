import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:regression/core/data/constants.dart';

part 'data_variable.freezed.dart';

@Freezed()
class DataVariable with _$DataVariable {
  const factory DataVariable({
    @Default(krGeneratedPrimaryKey) String id,
    required String label,
    required List<double> data,
  }) = _DataVariable;
}
