import 'package:regression/core/presentation/failure_converters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'failure_providers.g.dart';

@riverpod
CrudFailureConverter crudFailureConverter(CrudFailureConverterRef ref) {
  return CrudFailureConverter();
}

@Riverpod(keepAlive: true)
RegressionFailureConverter regressionFailureConverter(
    RegressionFailureConverterRef ref) {
  final crudFailureConverter = ref.read(crudFailureConverterProvider);
  var regressionFailureConverter = RegressionFailureConverter();
  regressionFailureConverter.registerConverter(crudFailureConverter.convert);
  return regressionFailureConverter;
}
